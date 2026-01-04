package cn.pzhdv.skyrocadminapi.controller;

import cn.pzhdv.skyrocadminapi.entity.SysRole;
import cn.pzhdv.skyrocadminapi.result.Result;
import cn.pzhdv.skyrocadminapi.result.ResultCode;
import cn.pzhdv.skyrocadminapi.result.ResultUtil;
import cn.pzhdv.skyrocadminapi.service.SysRoleButtonService;
import cn.pzhdv.skyrocadminapi.service.SysRoleService;
import cn.pzhdv.skyrocadminapi.vo.role.RoleButtonVO;
import io.swagger.annotations.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import javax.validation.constraints.Min;

/**
 * <p>
 * 角色-按钮权限关联表 前端控制器
 * </p>
 *
 * @author PanZonghui
 * @since 2026-05-06 13:39:50
 */
@Slf4j
@Validated
@Api(tags = "角色按钮权限管理")
@RestController
@RequestMapping("/sys-role-button")
@RequiredArgsConstructor
public class SysRoleButtonController {

    private final SysRoleService sysRoleService;
    private final SysRoleButtonService sysRoleButtonService;

    /**
     * 根据角色ID获取按钮列表
     */
    @ApiOperation(
            value = "根据角色ID获取按钮列表",
            notes = "根据角色ID从角色按钮中间表查询出角色拥有的按钮ID列表。",
            produces = "application/json"
    )
    @ApiImplicitParams({
            @ApiImplicitParam(
                    name = "roleId",
                    value = "角色ID（≥1）",
                    paramType = "path",
                    dataType = "Long",
                    required = true,
                    dataTypeClass = Long.class,
                    example = "1"
            )
    })
    @GetMapping("getButtonIdsByRoleId/{roleId}")
    public Result<RoleButtonVO> getButtonIdsByRoleId(
            @PathVariable
            @ApiParam(name = "roleId", value = "角色ID（≥1）", required = true)
            @Min(value = 1, message = "角色ID必须为正整数")
            Long roleId) {

        // 1. 校验角色是否存在
        SysRole role = sysRoleService.getById(roleId);
        if (role == null) {
            log.warn("【根据角色ID获取按钮列表】失败 | 角色不存在 | 角色ID: {}", roleId);
            return ResultUtil.error(ResultCode.DATA_NOT_FOUND, "角色不存在");
        }

        // 2. 从角色按钮中间表获取按钮ID列表
        RoleButtonVO roleButtonVO = new RoleButtonVO();
        roleButtonVO.setRoleId(role.getRoleId());
        roleButtonVO.setButtonIdList(sysRoleButtonService.getButtonIdsByRoleId(roleId));
        log.info("【根据角色ID获取按钮列表】成功 | 角色ID: {}", roleId);
        return ResultUtil.ok(roleButtonVO);
    }

    /**
     * 更新角色按钮权限
     */
    @ApiOperation(
            value = "更新角色按钮权限",
            notes = "更新角色的按钮权限。先删除该角色的所有旧按钮关联，再批量插入新的按钮关联。",
            produces = "application/json"
    )
    @ApiImplicitParams({
            @ApiImplicitParam(
                    name = "roleButtonVO",
                    value = "角色按钮权限信息（包含角色ID、按钮ID列表）",
                    paramType = "body",
                    required = true,
                    dataType = "RoleButtonVO",
                    dataTypeClass = RoleButtonVO.class
            )
    })
    @PutMapping("updateRoleButtonAuth")
    public Result<Boolean> updateRoleButtonAuth(@RequestBody @Valid RoleButtonVO roleButtonVO) {

        // 1. 参数校验
        Long roleId = roleButtonVO.getRoleId();
        if (roleId == null) {
            log.warn("【更新角色按钮权限】失败 | 角色ID不能为空");
            return ResultUtil.error(ResultCode.PARAM_REQUIRED, "角色ID不能为空");
        }

        // 2. 校验角色是否存在
        SysRole role = sysRoleService.getById(roleId);
        if (role == null) {
            log.warn("【更新角色按钮权限】失败 | 角色不存在 | 角色ID: {}", roleId);
            return ResultUtil.error(ResultCode.DATA_NOT_FOUND, "角色不存在");
        }

        // 3. 更新角色按钮关联
        boolean updateSuccess = sysRoleButtonService.updateRoleButtons(roleId, roleButtonVO.getButtonIdList());
        if (!updateSuccess) {
            log.error("【更新角色按钮权限】失败 | 更新按钮关联失败 | 角色ID: {}", roleId);
            return ResultUtil.error(ResultCode.UPDATE_FAIL, "更新按钮关联失败，请稍后重试");
        }

        log.info("【更新角色按钮权限】成功 | 角色ID: {}", roleId);
        return ResultUtil.ok(true);
    }

}
