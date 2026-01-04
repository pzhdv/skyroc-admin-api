package cn.pzhdv.skyrocadminapi.service.impl;

import cn.pzhdv.skyrocadminapi.constant.StatusConstants;
import cn.pzhdv.skyrocadminapi.entity.SysMenu;
import cn.pzhdv.skyrocadminapi.mapper.SysMenuMapper;
import cn.pzhdv.skyrocadminapi.service.SysMenuService;
import cn.pzhdv.skyrocadminapi.utils.QueryWrapperUtil;
import cn.pzhdv.skyrocadminapi.vo.common.TreeVO;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.util.*;
import java.util.stream.Collectors;

/**
 * <p>
 * 系统菜单表 服务实现类
 * </p>
 * <p>
 * 实现了菜单的查询、树形结构构建等功能，主要特性：
 * 1. 优化了N+1查询问题，使用批量查询和内存构建树形结构
 * 2. 支持分页查询菜单树
 * 3. 支持根据菜单ID列表获取完整的菜单路由树
 * 4. 支持将菜单转换为TreeVO格式，适配前端树形组件
 * </p>
 *
 * @author PanZonghui
 * @since 2026-01-02 18:04:32
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class SysMenuServiceImpl extends ServiceImpl<SysMenuMapper, SysMenu> implements SysMenuService {

    private final SysMenuMapper sysMenuMapper;

    /**
     * {@inheritDoc}
     * <p>
     * 实现说明：
     * 1. 先分页查询顶级菜单（parentId = rootParentId）
     * 2. 一次性查询所有符合条件的菜单
     * 3. 在内存中递归收集所有子菜单ID
     * 4. 使用Map构建父子关系映射，避免N+1查询
     * 5. 递归构建树形结构
     * </p>
     */
    @Override
    public Page<SysMenu> getMenuListTreePage(String menuName, Byte menuType, Byte status, Long rootParentId, Integer current, Integer size) {
        // 1. 分页查询顶级菜单（parentId = rootParentId）
        LambdaQueryWrapper<SysMenu> queryWrapper = buildBaseQueryWrapper(menuName, menuType, status);
        QueryWrapperUtil.addLambdaEqCondition(queryWrapper, SysMenu::getParentId, rootParentId);

        // 执行分页查询（仅查顶级菜单）
        Page<SysMenu> page = new Page<>(current, size);
        Page<SysMenu> resultPage = sysMenuMapper.selectPage(page, queryWrapper);

        // 2. 获取所有顶级菜单的ID，用于查询所有子菜单
        List<SysMenu> topMenuList = resultPage.getRecords();
        if (topMenuList.isEmpty()) {
            resultPage.setRecords(Collections.emptyList());
            return resultPage;
        }

        // 3. 一次性查询所有符合条件的菜单（包括所有层级的子菜单）
        List<Long> topMenuIds = topMenuList.stream()
                .map(SysMenu::getMenuId)
                .collect(Collectors.toList());
        List<SysMenu> allMenus = queryAllMenusWithChildren(menuName, menuType, status, topMenuIds);

        // 4. 在内存中构建树结构（避免N+1查询问题）
        Map<Long, List<SysMenu>> menuMap = allMenus.stream()
                .filter(menu -> menu.getParentId() != null && menu.getParentId() != 0)
                .collect(Collectors.groupingBy(SysMenu::getParentId));

        // 5. 为顶级菜单构建树结构
        List<SysMenu> treeList = buildMenuTree(topMenuList, menuMap);
        resultPage.setRecords(treeList);

        return resultPage;
    }

    /**
     * 构建基础查询条件（菜单名称、类型、状态）
     *
     * @param menuName 菜单名称（模糊）
     * @param menuType 菜单类型（精准）
     * @param status   菜单状态（精准）
     * @return 查询条件包装器
     */
    private LambdaQueryWrapper<SysMenu> buildBaseQueryWrapper(String menuName, Byte menuType, Byte status) {
        LambdaQueryWrapper<SysMenu> queryWrapper = new LambdaQueryWrapper<>();
        QueryWrapperUtil.addLambdaLikeCondition(queryWrapper, SysMenu::getMenuName, menuName);
        QueryWrapperUtil.addLambdaEqCondition(queryWrapper, SysMenu::getMenuType, menuType);
        QueryWrapperUtil.addLambdaEqCondition(queryWrapper, SysMenu::getStatus, status);
        // 按排序字段和创建时间排序
        queryWrapper.orderByAsc(SysMenu::getOrder);
        queryWrapper.orderByDesc(SysMenu::getCreateTime);
        return queryWrapper;
    }

    /**
     * 查询所有符合条件的菜单（包括所有层级的子菜单）
     * 优化：一次性查询所有相关菜单，避免N+1查询问题
     *
     * @param menuName   菜单名称（模糊）
     * @param menuType   菜单类型（精准）
     * @param status     菜单状态（精准）
     * @param topMenuIds 顶级菜单ID列表
     * @return 所有符合条件的菜单列表（仅包含属于当前分页顶级菜单树的数据）
     */
    private List<SysMenu> queryAllMenusWithChildren(String menuName, Byte menuType, Byte status,
                                                    List<Long> topMenuIds) {
        // 构建查询条件：查询所有符合条件的菜单（不限制parentId）
        LambdaQueryWrapper<SysMenu> queryWrapper = buildBaseQueryWrapper(menuName, menuType, status);
        List<SysMenu> allMenus = sysMenuMapper.selectList(queryWrapper);

        // 构建菜单ID到菜单对象的映射，便于快速查找
        Map<Long, SysMenu> menuIdMap = allMenus.stream()
                .collect(Collectors.toMap(SysMenu::getMenuId, menu -> menu, (k1, k2) -> k1));

        // 使用递归方式收集所有子菜单ID（包括所有层级）
        List<Long> allMenuIdsInTree = new ArrayList<>(topMenuIds);
        collectAllChildMenuIds(menuIdMap, topMenuIds, allMenuIdsInTree);

        // 收集所有子菜单ID（包括所有层级）后，按 order 升序、createTime 降序排序
        allMenuIdsInTree.sort((id1, id2) -> {
            SysMenu m1 = menuIdMap.get(id1);
            SysMenu m2 = menuIdMap.get(id2);
            if (m1 == null || m2 == null) return 0;
            // 先按 order 升序
            int orderCompare = Integer.compare(
                    m1.getOrder() != null ? m1.getOrder() : 0,
                    m2.getOrder() != null ? m2.getOrder() : 0
            );
            if (orderCompare != 0) return orderCompare;
            // order 相同则按 createTime 降序
            return m2.getCreateTime().compareTo(m1.getCreateTime());
        });

        // 返回属于当前树的所有菜单（保持原有顺序）
        return allMenuIdsInTree.stream()
                .map(menuIdMap::get)
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
    }

    /**
     * 递归收集所有子菜单ID
     *
     * @param menuIdMap        菜单ID到菜单对象的映射
     * @param parentIds        父菜单ID列表
     * @param collectedMenuIds 已收集的菜单ID列表（结果集）
     */
    private void collectAllChildMenuIds(Map<Long, SysMenu> menuIdMap, List<Long> parentIds, List<Long> collectedMenuIds) {
        if (parentIds == null || parentIds.isEmpty()) {
            return;
        }

        // 查找当前层级的所有子菜单
        List<Long> childIds = menuIdMap.values().stream()
                .filter(menu -> {
                    Long parentId = menu.getParentId();
                    return parentId != null && parentIds.contains(parentId);
                })
                .map(SysMenu::getMenuId)
                .collect(Collectors.toList());

        if (!childIds.isEmpty()) {
            collectedMenuIds.addAll(childIds);
            // 递归收集下一层级的子菜单
            collectAllChildMenuIds(menuIdMap, childIds, collectedMenuIds);
        }
    }


    /**
     * {@inheritDoc}
     * <p>
     * 实现说明：
     * 1. 查询指定菜单ID列表的菜单（只查询启用的菜单）
     * 2. 向上递归收集所有父级菜单ID（保证树形结构完整）
     * 3. 向下递归收集所有子菜单ID（包含所有层级）
     * 4. 一次性查询所有需要的菜单（父级+子级）
     * 5. 在内存中构建完整的树形结构
     * </p>
     */
    @Override
    public List<SysMenu> getMenuRoutesByIds(List<Long> menuIds) {
        // 参数校验
        if (CollectionUtils.isEmpty(menuIds)) {
            return Collections.emptyList();
        }

        // 1. 查询所有指定的菜单（只查询启用的菜单）
        LambdaQueryWrapper<SysMenu> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.in(SysMenu::getMenuId, menuIds);
        queryWrapper.eq(SysMenu::getStatus, StatusConstants.MENU_STATUS_ENABLED); // 只查询启用的菜单
        queryWrapper.orderByAsc(SysMenu::getOrder);
        queryWrapper.orderByDesc(SysMenu::getCreateTime);
        List<SysMenu> menus = sysMenuMapper.selectList(queryWrapper);

        if (CollectionUtils.isEmpty(menus)) {
            return Collections.emptyList();
        }

        // 2. 收集所有菜单ID（包括查询到的菜单、所有父级菜单ID和所有子菜单ID）
        Set<Long> allMenuIds = new HashSet<>(menuIds);
        collectAllParentMenuIds(menus, allMenuIds);
        collectAllChildMenuIds(menus, allMenuIds);

        // 3. 查询所有需要的菜单（包括父级菜单和子菜单）
        if (allMenuIds.size() > menuIds.size()) {
            LambdaQueryWrapper<SysMenu> allQueryWrapper = new LambdaQueryWrapper<>();
            allQueryWrapper.in(SysMenu::getMenuId, allMenuIds);
            allQueryWrapper.eq(SysMenu::getStatus, StatusConstants.MENU_STATUS_ENABLED);
            allQueryWrapper.orderByAsc(SysMenu::getOrder);
            allQueryWrapper.orderByDesc(SysMenu::getCreateTime);
            menus = sysMenuMapper.selectList(allQueryWrapper);
        }

        // 4. 构建父子关系映射
        Map<Long, List<SysMenu>> childrenMap = menus.stream()
                .filter(menu -> menu.getParentId() != null && menu.getParentId() != 0)
                .collect(Collectors.groupingBy(SysMenu::getParentId));

        // 5. 构建树形结构
        List<SysMenu> rootMenus = menus.stream()
                .filter(menu -> menu.getParentId() == null || menu.getParentId() == 0)
                .collect(Collectors.toList());

        return buildMenuTree(rootMenus, childrenMap);
    }

    /**
     * {@inheritDoc}
     * <p>
     * 实现说明：
     * 1. 查询所有启用的菜单
     * 2. 构建父子关系映射（使用Map优化查找性能）
     * 3. 根据rootParentId获取根节点菜单
     * 4. 递归构建TreeVO树形结构
     * </p>
     */
    @Override
    public List<TreeVO> getAllMenuTree(Long rootParentId) {
        // 1. 查询所有启用的菜单
        LambdaQueryWrapper<SysMenu> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(SysMenu::getStatus, StatusConstants.MENU_STATUS_ENABLED); // 只查询启用的菜单
        queryWrapper.orderByAsc(SysMenu::getOrder);
        queryWrapper.orderByDesc(SysMenu::getCreateTime);
        List<SysMenu> allMenus = sysMenuMapper.selectList(queryWrapper);

        if (CollectionUtils.isEmpty(allMenus)) {
            return Collections.emptyList();
        }

        // 2. 构建父子关系映射
        Map<Long, List<SysMenu>> childrenMap = allMenus.stream()
                .filter(menu -> menu.getParentId() != null && menu.getParentId() != 0)
                .collect(Collectors.groupingBy(SysMenu::getParentId));

        // 3. 获取根节点菜单（parentId = rootParentId）
        List<SysMenu> rootMenus = allMenus.stream()
                .filter(menu -> rootParentId.equals(menu.getParentId()))
                .collect(Collectors.toList());

        // 4. 构建树形结构并转换为TreeVO
        return buildTreeVO(rootMenus, childrenMap);
    }

    /**
     * {@inheritDoc}
     * <p>
     * 实现说明：
     * 1. 根据菜单类型查询所有启用的菜单
     * 2. 按排序字段和创建时间排序
     * 3. 返回平铺的菜单列表
     * </p>
     */
    @Override
    public List<SysMenu> getAllPages(Byte menuType) {
        LambdaQueryWrapper<SysMenu> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(SysMenu::getStatus, StatusConstants.MENU_STATUS_ENABLED); // 只查询启用的菜单
        queryWrapper.eq(SysMenu::getMenuType, menuType); // 根据传入的菜单类型查询
        queryWrapper.orderByAsc(SysMenu::getOrder);
        queryWrapper.orderByDesc(SysMenu::getCreateTime);
        return sysMenuMapper.selectList(queryWrapper);
    }

    /**
     * 构建TreeVO树形结构
     *
     * @param parentMenus 父级菜单列表
     * @param childrenMap 子菜单映射表（key: parentId, value: 子菜单列表）
     * @return TreeVO树形结构
     */
    private List<TreeVO> buildTreeVO(List<SysMenu> parentMenus, Map<Long, List<SysMenu>> childrenMap) {
        if (CollectionUtils.isEmpty(parentMenus)) {
            return Collections.emptyList();
        }

        return parentMenus.stream().map(menu -> {
            TreeVO treeVO = new TreeVO();
            treeVO.setValue(menu.getMenuId());
            treeVO.setLabel(menu.getMenuName());
            treeVO.setI18nKey(menu.getI18nKey());

            // 获取并排序子菜单
            List<SysMenu> children = childrenMap.get(menu.getMenuId());
            if (!CollectionUtils.isEmpty(children)) {
                children.sort((m1, m2) -> {
                    int orderCompare = Integer.compare(
                            m1.getOrder() != null ? m1.getOrder() : 0,
                            m2.getOrder() != null ? m2.getOrder() : 0
                    );
                    if (orderCompare != 0) return orderCompare;
                    return m2.getCreateTime().compareTo(m1.getCreateTime());
                });
                treeVO.setChildren(buildTreeVO(children, childrenMap));
            }

            return treeVO;
        }).collect(Collectors.toList());
    }

    /**
     * 递归收集所有父级菜单ID（向上查找）
     *
     * @param menus      菜单列表
     * @param allMenuIds 已收集的菜单ID集合（结果集）
     */
    private void collectAllParentMenuIds(List<SysMenu> menus, Set<Long> allMenuIds) {
        Set<Long> parentIds = menus.stream()
                .map(SysMenu::getParentId)
                .filter(Objects::nonNull)
                .filter(parentId -> parentId != 0)
                .filter(parentId -> !allMenuIds.contains(parentId))
                .collect(Collectors.toSet());

        if (!parentIds.isEmpty()) {
            allMenuIds.addAll(parentIds);
            LambdaQueryWrapper<SysMenu> queryWrapper = new LambdaQueryWrapper<>();
            queryWrapper.in(SysMenu::getMenuId, parentIds);
            queryWrapper.eq(SysMenu::getStatus, StatusConstants.MENU_STATUS_ENABLED);
            List<SysMenu> parentMenus = sysMenuMapper.selectList(queryWrapper);
            if (!CollectionUtils.isEmpty(parentMenus)) {
                collectAllParentMenuIds(parentMenus, allMenuIds);
            }
        }
    }

    /**
     * 递归收集所有子菜单ID（向下查找）
     *
     * @param menus      菜单列表
     * @param allMenuIds 已收集的菜单ID集合（结果集）
     */
    private void collectAllChildMenuIds(List<SysMenu> menus, Set<Long> allMenuIds) {
        Set<Long> currentMenuIds = menus.stream()
                .map(SysMenu::getMenuId)
                .collect(Collectors.toSet());

        LambdaQueryWrapper<SysMenu> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.in(SysMenu::getParentId, currentMenuIds);
        queryWrapper.eq(SysMenu::getStatus, StatusConstants.MENU_STATUS_ENABLED);
        List<SysMenu> childMenus = sysMenuMapper.selectList(queryWrapper);

        if (!CollectionUtils.isEmpty(childMenus)) {
            Set<Long> childIds = childMenus.stream()
                    .map(SysMenu::getMenuId)
                    .filter(menuId -> !allMenuIds.contains(menuId))
                    .collect(Collectors.toSet());

            if (!childIds.isEmpty()) {
                allMenuIds.addAll(childIds);
                collectAllChildMenuIds(childMenus, allMenuIds);
            }
        }
    }

    /**
     * 构建菜单树形结构
     *
     * @param parentMenus 父级菜单列表
     * @param childrenMap 子菜单映射表（key: parentId, value: 子菜单列表）
     * @return 构建好的菜单树
     */
    private List<SysMenu> buildMenuTree(List<SysMenu> parentMenus, Map<Long, List<SysMenu>> childrenMap) {
        if (CollectionUtils.isEmpty(parentMenus)) {
            return Collections.emptyList();
        }

        for (SysMenu parentMenu : parentMenus) {
            List<SysMenu> children = childrenMap.get(parentMenu.getMenuId());
            if (!CollectionUtils.isEmpty(children)) {
                // 对子菜单按 order 升序、createTime 降序排序
                children.sort((m1, m2) -> {
                    int orderCompare = Integer.compare(
                            m1.getOrder() != null ? m1.getOrder() : 0,
                            m2.getOrder() != null ? m2.getOrder() : 0
                    );
                    if (orderCompare != 0) return orderCompare;
                    return m2.getCreateTime().compareTo(m1.getCreateTime());
                });
                parentMenu.setChildren(buildMenuTree(children, childrenMap));
            } else {
                parentMenu.setChildren(null);
            }
        }

        return parentMenus;
    }
}