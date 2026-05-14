SET NAMES utf8mb4;
SET
FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- 菜单表结构
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`
(
    `menu_id`            bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '菜单ID（主键）',
    `menu_type`          tinyint(0) NOT NULL DEFAULT 1 COMMENT '菜单类型：1=目录，2=菜单（枚举值不可修改）',
    `menu_name`          varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '菜单名称（如：系统管理,用户管理）',
    `route_name`         varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '路由名称(如：manage,manage_user)',
    `route_path`         varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '路由路径（如：/manage,/manage/user）',
    `component`          varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '组件路径（如：layout.base$view.home、view.manage_user，空表示无组件；允许$符号）',
    `layout`             varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '布局类型（如：\"(base)\"、\"(blank)\"，允许()符号）',
    `i18n_key`           varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '国际化key（对应语言包）',
    `order`              smallint(0) UNSIGNED NULL DEFAULT 0 COMMENT '菜单排序（数字越小越靠前）',
    `icon_type`          tinyint(0) NULL DEFAULT 1 COMMENT '图标类型：1=iconify图标，2=本地图标（枚举值不可修改）',
    `icon`               varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图标标识（如：ep:menu）',
    `status`             tinyint(0) NOT NULL DEFAULT 1 COMMENT '菜单状态：1=启用，2=禁用（枚举值不可修改）',
    `keep_alive`         tinyint(1) NOT NULL DEFAULT 0 COMMENT '缓存路由：0=false=否，1=true=是',
    `constant`           tinyint(1) NOT NULL DEFAULT 0 COMMENT '常量路由：0=false=否，1=true=是',
    `href`               varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '外链地址（http/https开头）',
    `hide_in_menu`       tinyint(1) NOT NULL DEFAULT 0 COMMENT '隐藏菜单：0=false=否，1=true=是',
    `parent_id`          bigint(0) UNSIGNED NOT NULL DEFAULT 0 COMMENT '父级菜单ID（0表示根菜单）',
    `active_menu`        varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '高亮的菜单（指定menu_id，用于非菜单页高亮）',
    `deleted`            tinyint(0) NULL DEFAULT 0 COMMENT '删除状态：0=未删,1=已删（枚举值不可修改）',
    `create_time`        datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
    `update_time`        datetime(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
    `multi_tab`          tinyint(1) NOT NULL DEFAULT 0 COMMENT '支持多页签：0=false=否，1=true=是',
    `fixed_index_in_tab` smallint(0) UNSIGNED NULL DEFAULT NULL COMMENT '固定在页签中的序号（NULL表示不固定，数字越小越靠前）',
    `query`              text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '路由参数（JSON格式，示例：[{\"key\":\"age\",\"value\":\"18\"},{\"key\":\"id\",\"value\":\"1001\"}]，仅允许合法JSON字符串）',
    PRIMARY KEY (`menu_id`) USING BTREE,
    UNIQUE INDEX `uk_route_path`(`route_path`) USING BTREE,
    UNIQUE INDEX `uk_route_name`(`route_name`) USING BTREE,
    INDEX                `idx_parent_id_deleted`(`parent_id`, `deleted`) USING BTREE,
    INDEX                `idx_order_num_deleted`(`order`, `deleted`) USING BTREE,
    INDEX                `idx_status_deleted`(`status`, `deleted`) USING BTREE,
    INDEX                `idx_menu_type_deleted`(`menu_type`, `deleted`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 44 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统菜单表' ROW_FORMAT = Dynamic;

-- ----------菜单表插入数据------------------
-- 1. 基础菜单：首页 / 关于
-- ----------------------------
INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, '首页', 'home', '/home', 'page.(base)_home', '(base)', 'route.(base)_home', 1, 1, 'mdi:monitor-dashboard', 1,
        0, 0, NULL, 0, 0, NULL, 0, 0, NULL, NULL);

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, '关于', 'about', '/about', 'page.(base)_about', '(base)', 'route.(base)_about', 9, 1,
        'fluent:book-information-24-regular', 1, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, NULL);

-- ----------------------------
-- 2. 系统功能
-- ----------------------------
INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (1, '系统功能', 'function', '/function', 'page.(base)_function', '(base)', 'route.(base)_function', 6, 1,
        'icon-park-outline:all-application', 1, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, NULL);
SET
@func_parent_id = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, '事件总线演示', 'function_event-bus', '/function/event-bus', 'page.(base)_function_event-bus', '',
        'route.(base)_function_event-bus', 0, 1, 'ant-design:send-outlined', 1, 0, 0, NULL, 0, @func_parent_id, NULL, 0,
        0, NULL, NULL);

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (1, '隐藏子菜单', 'function_hide-child', '/function/hide-child', 'page.(base)_function_hide-child', '(base)',
        'route.(base)_function_hide-child', 2, 1, 'material-symbols:filter-list-off', 1, 0, 0, NULL, 0, @func_parent_id,
        NULL, 0, 0, NULL, NULL);
SET
@hide_child_parent_id = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, '隐藏子菜单', 'function_hide-child_one', '/function/hide-child/one', 'page.(base)_function_hide-child_one',
        '', 'route.(base)_function_hide-child_one', 0, 1, NULL, 1, 0, 0, NULL, 1, @hide_child_parent_id,
        '/function/hide-child', 0, 0, NULL, NULL);

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, '菜单二', 'function_hide-child_two', '/function/hide-child/two', 'page.(base)_function_hide-child_two', '',
        'route.(base)_function_hide-child_two', 0, 1, NULL, 1, 0, 0, NULL, 1, @hide_child_parent_id,
        '/function/hide-child', 0, 0, NULL, NULL);

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, '菜单三', 'function_hide-child_three', '/function/hide-child/three', 'page.(base)_function_hide-child_three',
        '', 'route.(base)_function_hide-child_three', 0, 1, NULL, 1, 0, 0, NULL, 1, @hide_child_parent_id,
        '/function/hide-child', 0, 0, NULL, NULL);

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, '多标签页', 'function_multi-tab', '/function/multi-tab', 'page.(base)_function_multi-tab', '',
        'route.(base)_function_multi-tab', 0, 1, 'ic:round-tab', 1, 0, 0, NULL, 1, @func_parent_id, '/function/tab', 0,
        1, NULL, NULL);

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, '请求', 'function_request', '/function/request', 'page.(base)_function_request', '',
        'route.(base)_function_request', 3, 1, 'carbon:network-overlay', 1, 0, 0, NULL, 0, @func_parent_id, NULL, 0, 0,
        NULL, NULL);

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, '超级管理员可见', 'function_super-page', '/function/super-page', 'page.(base)_function_super-page', '',
        'route.(base)_function_super-page', 5, 1, 'ic:round-supervisor-account', 1, 0, 0, NULL, 0, @func_parent_id,
        NULL, 0, 0, NULL, NULL);

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, '标签页', 'function_tab', '/function/tab', 'page.(base)_function_tab', '', 'route.(base)_function_tab', 1, 1,
        'ic:round-tab', 1, 1, 0, NULL, 0, @func_parent_id, NULL, 0, 0, NULL, NULL);

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, '切换权限', 'function_toggle-auth', '/function/toggle-auth', 'page.(base)_function_toggle-auth', '',
        'route.(base)_function_toggle-auth', 4, 1, 'ic:round-construction', 1, 0, 0, NULL, 0, @func_parent_id, NULL, 0,
        0, NULL, NULL);

-- ----------------------------
-- 3. 系统管理（用户、角色、菜单、按钮、日志）
-- ----------------------------
INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (1, '系统管理', 'manage', '/manage', 'page.(base)_manage', '(base)', 'route.(base)_manage', 8, 1,
        'carbon:cloud-service-management', 1, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, NULL);
SET
@manage_parent_id = LAST_INSERT_ID();

-- 用户管理
INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, '用户管理', 'manage_user', '/manage/user', 'page.(base)_manage_user', '', 'route.(base)_manage_user', 1, 1,
        'ic:round-manage-accounts', 1, 1, 0, '', 0, @manage_parent_id, NULL, 0, 0, NULL, '[]');
SET
@user_manage_id = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, '用户详情', 'manage_user_[id]', '/manage/user/:id', 'page.(base)_manage_user_[id]', '',
        'route.(base)_manage_user_[id]', 0, 1, NULL, 1, 0, 0, NULL, 1, @user_manage_id, '/manage/user', 0, 0, NULL,
        NULL);

-- 角色管理
INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, '角色管理', 'manage_role', '/manage/role', 'page.(base)_manage_role', '', 'route.(base)_manage_role', 2, 1,
        'carbon:user-role', 1, 0, 0, '', 0, @manage_parent_id, NULL, 0, 0, NULL, '[]');
SET
@role_manage_id = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, '角色管理详情', 'manage_role_[...slug]', '/manage/role/*', 'page.(base)_manage_role_[...slug]', '',
        'route.(base)_manage_role_[...slug]', 0, 1, NULL, 1, 0, 0, NULL, 1, @role_manage_id, '/manage/role', 0, 0, NULL,
        NULL);

-- 菜单管理
INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, '菜单管理', 'manage_menu', '/manage/menu', 'page.(base)_manage_menu', '', 'route.(base)_manage_menu', 3, 1,
        'material-symbols:route', 1, 0, 0, '', 0, @manage_parent_id, NULL, 0, 0, NULL, '[]');

-- 按钮管理
INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, '按钮管理', 'manage_button', '/manage/button', 'page.(base)_manage_button', '', 'route.(base)_manage_button',
        4, 1, 'streamline-sharp-color:buttons-all', 1, 0, 0, '', 0, @manage_parent_id, NULL, 0, 0, NULL, '[]');

-- 日志管理
INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, '操作日志', 'manage_operation-log', '/manage/operation-log', 'page.(base)_manage_operation-log', '', 'route.(base)_manage_operation-log',
        5, 1, 'material-symbols:history', 1, 0, 0, '', 0, @manage_parent_id, NULL, 0, 0, NULL, '[]');

-- ----------------------------
-- 4. 多级菜单
-- ----------------------------
INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (1, '多级菜单', 'multi-menu', '/multi-menu', 'page.(base)_multi-menu', '(base)', 'route.(base)_multi-menu', 5, 1,
        NULL, 1, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, NULL);
SET
@multi_menu_parent_id = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (1, '菜单一', 'multi-menu_first', '/multi-menu/first', 'page.(base)_multi-menu_first', '(base)',
        'route.(base)_multi-menu_first', 0, 1, NULL, 1, 0, 0, NULL, 0, @multi_menu_parent_id, NULL, 0, 0, NULL, NULL);
SET
@multi_menu_first_id = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, '菜单一子菜单', 'multi-menu_first_child', '/multi-menu/first/child', 'page.(base)_multi-menu_first_child',
        '', 'route.(base)_multi-menu_first_child', 0, 1, NULL, 1, 0, 0, NULL, 0, @multi_menu_first_id, NULL, 0, 0, NULL,
        NULL);

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (1, '菜单二', 'multi-menu_second', '/multi-menu/second', 'page.(base)_multi-menu_second', '(base)',
        'route.(base)_multi-menu_second', 0, 1, NULL, 1, 0, 0, NULL, 0, @multi_menu_parent_id, NULL, 0, 0, NULL, NULL);
SET
@multi_menu_second_id = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (1, '菜单二子菜单', 'multi-menu_second_child', '/multi-menu/second/child', 'page.(base)_multi-menu_second_child',
        '(base)', 'route.(base)_multi-menu_second_child', 0, 1, NULL, 1, 0, 0, NULL, 0, @multi_menu_second_id, NULL, 0,
        0, NULL, NULL);
SET
@multi_menu_second_child_id = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, '菜单二子菜单首页', 'multi-menu_second_child_home', '/multi-menu/second/child/home',
        'page.(base)_multi-menu_second_child_home', '', 'route.(base)_multi-menu_second_child_home', 0, 1, NULL, 1, 0,
        0, NULL, 0, @multi_menu_second_child_id, NULL, 0, 0, NULL, NULL);

-- ----------------------------
-- 5. 多级动态路由
-- ----------------------------
INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (1, '多级动态路由', 'projects', '/projects', 'page.(base)_projects', '(base)', 'route.(base)_projects', 7, 1,
        'hugeicons:align-box-top-center', 1, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, NULL);
SET
@projects_parent_id = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, '多级动态路由详情', 'projects_[pid]', '/projects/:pid', 'page.(base)_projects_[pid]', '',
        'route.(base)_projects_[pid]', 0, 1, 'material-symbols-light:attachment', 1, 0, 0, NULL, 0, @projects_parent_id,
        NULL, 0, 0, NULL, NULL);
SET
@projects_pid_id = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, '多级动态路由编辑', 'projects_[pid]_edit', '/projects/:pid/edit', 'page.(base)_projects_[pid]_edit', '',
        'route.(base)_projects_[pid]_edit', 0, 1, 'material-symbols-light:assistant-on-hub-outline', 1, 0, 0, NULL, 0,
        @projects_pid_id, NULL, 0, 0, NULL, NULL);
SET
@projects_edit_id = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, '多级动态路由编辑详情', 'projects_[pid]_edit_[id]', '/projects/:pid/edit/:id',
        'page.(base)_projects_[pid]_edit_[id]', '', 'route.(base)_projects_[pid]_edit_[id]', 0, 1, NULL, 1, 0, 0, NULL,
        0, @projects_edit_id, NULL, 0, 0, NULL, NULL);

-- ----------------------------
-- 6. 个人中心
-- ----------------------------
INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, '个人中心', 'user-center', '/user-center', 'page.(base)_user-center', '(base)', 'route.(base)_user-center',
        0, 1, NULL, 1, 0, 0, NULL, 1, 0, NULL, 0, 0, NULL, NULL);

-- ----------------------------
-- 7. 异常页面
-- ----------------------------
INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (1, '异常页面', 'exception', '/exception', NULL, '(base)', 'route.exception', 4, 1,
        'ant-design:exception-outlined', 1, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, NULL);
SET
@exception_parent_id = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, '403异常', 'exception_403', '/exception/403', 'page.403', '', 'route.exception_403', 0, 1,
        'ic:baseline-block', 1, 0, 0, NULL, 0, @exception_parent_id, NULL, 0, 0, NULL, NULL);

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, '404异常', 'exception_404', '/exception/404', 'page.404', '', 'route.exception_404', 0, 1,
        'ic:baseline-web-asset-off', 1, 0, 0, NULL, 0, @exception_parent_id, NULL, 0, 0, NULL, NULL);

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, '500异常', 'exception_500', '/exception/500', 'page.500', '', 'route.exception_500', 0, 1,
        'ic:baseline-wifi-off', 1, 0, 0, NULL, 0, @exception_parent_id, NULL, 0, 0, NULL, NULL);

-- ----------------------------
-- 8. 文档中心
-- ----------------------------
INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (1, '文档中心', 'document', '/document', NULL, '(base)', 'route.document', 2, 1,
        'mdi:file-document-multiple-outline', 1, 0, 0, NULL, 0, 0, NULL, 0, 0, NULL, NULL);
SET
@document_parent_id = LAST_INSERT_ID();

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, 'Ant Design文档', 'document_antd', '/document/antd', 'page.iframe-page', '', 'route.document_antd', 7, 1,
        'logos:ant-design', 1, 0, 0, 'https://ant.design/index-cn', 0, @document_parent_id, NULL, 0, 0, NULL, NULL);

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, 'ProComponents文档', 'document_procomponents', '/document/procomponents', 'page.iframe-page', '',
        'route.document_procomponents', 8, 1, 'logos:ant-design', 1, 0, 0, 'https://pro-components.antdigital.dev/', 0,
        @document_parent_id, NULL, 0, 0, NULL, NULL);

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, 'UI演示文档', 'document_ui', '/document/ui', 'page.iframe-page', '', 'route.document_ui', 0, 2, 'logo', 1, 0,
        0, 'https://ui-play.skyroc.me/button', 0, @document_parent_id, NULL, 0, 0, NULL, NULL);

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, '项目文档', 'document_project', '/document/project', 'page.iframe-page', '', 'route.document_project', 1, 2,
        'logo', 1, 0, 0, 'https://admin-docs.skyroc.me', 0, @document_parent_id, NULL, 0, 0, NULL, NULL);

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, '项目文档链接', 'document_project-link', '/document/project-link', 'page.iframe-page', '',
        'route.document_project-link', 2, 2, 'logo', 1, 0, 0, 'https://admin-docs.skyroc.me', 0, @document_parent_id,
        NULL, 0, 0, NULL, NULL);

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, 'UnoCSS文档', 'document_unocss', '/document/unocss', 'page.iframe-page', '', 'route.document_unocss', 5, 1,
        'logos:unocss', 1, 0, 0, 'https://unocss.dev/', 0, @document_parent_id, NULL, 0, 0, NULL, NULL);

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, 'Vite文档', 'document_vite', '/document/vite', 'page.iframe-page', '', 'route.document_vite', 4, 1,
        'logos:vitejs', 1, 0, 0, 'https://cn.vitejs.dev/', 0, @document_parent_id, NULL, 0, 0, NULL, NULL);

INSERT INTO `sys_menu` (`menu_type`, `menu_name`, `route_name`, `route_path`, `component`, `layout`, `i18n_key`,
                        `order`, `icon_type`, `icon`, `status`, `keep_alive`, `constant`, `href`, `hide_in_menu`,
                        `parent_id`, `active_menu`, `deleted`, `multi_tab`, `fixed_index_in_tab`, `query`)
VALUES (2, 'React文档', 'document_react', '/document/react', 'page.iframe-page', '', 'route.document_react', 3, 1,
        'logos:react', 1, 0, 0, 'https://react.dev/', 0, @document_parent_id, NULL, 0, 0, NULL, NULL);

SET
FOREIGN_KEY_CHECKS = 1;
