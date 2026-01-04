/*
 Navicat Premium Data Transfer

 Source Server         : 本机mysql
 Source Server Type    : MySQL
 Source Server Version : 80200
 Source Host           : localhost:3306
 Source Schema         : skyroc-admin-db

 Target Server Type    : MySQL
 Target Server Version : 80200
 File Encoding         : 65001

 Date: 08/05/2026 12:19:55
*/

SET NAMES utf8mb4;
SET
FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for sys_button
-- ----------------------------
DROP TABLE IF EXISTS `sys_button`;
CREATE TABLE `sys_button`
(
    `button_id`   bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '按钮ID（主键）',
    `menu_id`     bigint(0) UNSIGNED NOT NULL COMMENT '关联菜单ID（sys_menu.menu_id）',
    `button_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '按钮编码（唯一，如：btn:sys:user:add/btn:sys:user:edit）',
    `button_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci  NOT NULL COMMENT '按钮名称（如：新增、编辑、删除）',
    `status`      tinyint(0) NOT NULL DEFAULT 1 COMMENT '状态：1=启用 2=禁用',
    `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
    `update_time` datetime(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
    PRIMARY KEY (`button_id`) USING BTREE,
    UNIQUE INDEX `uk_button_code`(`button_code`) USING BTREE,
    INDEX         `idx_menu_id`(`menu_id`) USING BTREE,
    INDEX         `idx_status_deleted`(`status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统菜单按钮权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_button
-- ----------------------------
INSERT INTO `sys_button`
VALUES (7, 44, 'btn:sys:button:add', '新增', 1, '2026-05-05 23:06:17', '2026-05-05 23:41:01');
INSERT INTO `sys_button`
VALUES (8, 44, 'btn:sys:button:edit', '编辑', 1, '2026-05-05 23:06:50', '2026-05-05 23:40:39');
INSERT INTO `sys_button`
VALUES (9, 44, 'btn:sys:button:delete', '删除', 1, '2026-05-05 23:41:35', '2026-05-05 23:41:35');
INSERT INTO `sys_button`
VALUES (10, 44, 'btn:sys:button:batchDel', '批量删除', 1, '2026-05-05 23:42:00', '2026-05-05 23:42:00');
INSERT INTO `sys_button`
VALUES (11, 15, 'btn:sys:user:add', '新增', 1, '2026-05-06 17:40:20', '2026-05-06 17:40:20');
INSERT INTO `sys_button`
VALUES (12, 15, 'btn:sys:user:edit', '编辑', 1, '2026-05-06 17:40:20', '2026-05-06 17:40:20');
INSERT INTO `sys_button`
VALUES (13, 15, 'btn:sys:user:delete', '删除', 1, '2026-05-06 17:40:20', '2026-05-06 17:40:20');
INSERT INTO `sys_button`
VALUES (14, 15, 'btn:sys:user:batchDel', '批量删除', 1, '2026-05-06 17:40:20', '2026-05-06 17:40:20');
INSERT INTO `sys_button`
VALUES (15, 15, 'btn:sys:user:detail', '详情', 1, '2026-05-06 17:40:20', '2026-05-06 17:40:20');
INSERT INTO `sys_button`
VALUES (16, 19, 'btn:sys:menu:add', '新增', 1, '2026-05-06 17:47:00', '2026-05-06 17:47:00');
INSERT INTO `sys_button`
VALUES (17, 19, 'btn:sys:menu:edit', '编辑', 1, '2026-05-06 17:47:00', '2026-05-06 17:47:00');
INSERT INTO `sys_button`
VALUES (18, 19, 'btn:sys:menu:delete', '删除', 1, '2026-05-06 17:47:00', '2026-05-06 17:47:00');
INSERT INTO `sys_button`
VALUES (19, 19, 'btn:sys:menu:addChild', '新增子菜单', 1, '2026-05-06 17:47:00', '2026-05-07 13:51:55');
INSERT INTO `sys_button`
VALUES (20, 17, 'btn:sys:role:add', '新增', 1, '2026-05-06 17:47:00', '2026-05-06 17:47:00');
INSERT INTO `sys_button`
VALUES (21, 17, 'btn:sys:role:edit', '编辑', 1, '2026-05-06 17:47:00', '2026-05-06 17:47:00');
INSERT INTO `sys_button`
VALUES (22, 17, 'btn:sys:role:delete', '删除', 1, '2026-05-06 17:47:00', '2026-05-06 17:47:00');
INSERT INTO `sys_button`
VALUES (23, 17, 'btn:sys:role:batchDel', '批量删除', 1, '2026-05-06 17:47:00', '2026-05-06 17:47:00');
INSERT INTO `sys_button`
VALUES (24, 17, 'btn:sys:role:detail', '详情', 1, '2026-05-06 17:47:00', '2026-05-06 17:47:00');
INSERT INTO `sys_button`
VALUES (25, 13, 'btn:function:auth:super:view', '超级管理员可见', 1, '2026-05-06 11:52:43', '2026-05-07 14:49:03');
INSERT INTO `sys_button`
VALUES (26, 13, 'btn:function:auth:admin:view', '管理员可见', 1, '2026-05-06 11:53:06', '2026-05-07 14:49:26');
INSERT INTO `sys_button`
VALUES (27, 13, 'btn:function:auth:user:view', '管理员/用户可见', 1, '2026-05-06 11:53:34', '2026-05-07 14:53:06');

-- ----------------------------
-- Table structure for sys_menu
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
) ENGINE = InnoDB AUTO_INCREMENT = 45 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统菜单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu`
VALUES (1, 2, '首页', 'home', '/home', 'page.(base)_home', '(base)', 'route.(base)_home', 1, 1, 'mdi:monitor-dashboard',
        1, 0, 0, NULL, 0, 0, NULL, 0, '2026-01-04 11:31:54', NULL, 0, NULL, NULL);
INSERT INTO `sys_menu`
VALUES (2, 2, '关于', 'about', '/about', 'page.(base)_about', '(base)', 'route.(base)_about', 9, 1,
        'fluent:book-information-24-regular', 1, 0, 0, NULL, 0, 0, NULL, 0, '2026-01-04 11:31:54', NULL, 0, NULL, NULL);
INSERT INTO `sys_menu`
VALUES (3, 1, '系统功能', 'function', '/function', 'page.(base)_function', '(base)', 'route.(base)_function', 6, 1,
        'icon-park-outline:all-application', 1, 0, 0, NULL, 0, 0, NULL, 0, '2026-01-04 11:31:54', NULL, 0, NULL, NULL);
INSERT INTO `sys_menu`
VALUES (4, 2, '事件总线演示', 'function_event-bus', '/function/event-bus', 'page.(base)_function_event-bus', '',
        'route.(base)_function_event-bus', 0, 1, 'ant-design:send-outlined', 1, 0, 0, NULL, 0, 3, NULL, 0,
        '2026-01-04 11:31:54', NULL, 0, NULL, NULL);
INSERT INTO `sys_menu`
VALUES (5, 1, '隐藏子菜单', 'function_hide-child', '/function/hide-child', 'page.(base)_function_hide-child', '(base)',
        'route.(base)_function_hide-child', 2, 1, 'material-symbols:filter-list-off', 1, 0, 0, NULL, 0, 3, NULL, 0,
        '2026-01-04 11:31:54', NULL, 0, NULL, NULL);
INSERT INTO `sys_menu`
VALUES (6, 2, '隐藏子菜单', 'function_hide-child_one', '/function/hide-child/one',
        'page.(base)_function_hide-child_one', '', 'route.(base)_function_hide-child_one', 0, 1, NULL, 1, 0, 0, NULL, 1,
        5, '/function/hide-child', 0, '2026-01-04 11:31:54', NULL, 0, NULL, NULL);
INSERT INTO `sys_menu`
VALUES (7, 2, '菜单二', 'function_hide-child_two', '/function/hide-child/two', 'page.(base)_function_hide-child_two',
        '', 'route.(base)_function_hide-child_two', 0, 1, NULL, 1, 0, 0, NULL, 1, 5, '/function/hide-child', 0,
        '2026-01-04 11:31:54', NULL, 0, NULL, NULL);
INSERT INTO `sys_menu`
VALUES (8, 2, '菜单三', 'function_hide-child_three', '/function/hide-child/three',
        'page.(base)_function_hide-child_three', '', 'route.(base)_function_hide-child_three', 0, 1, NULL, 1, 0, 0,
        NULL, 1, 5, '/function/hide-child', 0, '2026-01-04 11:31:54', NULL, 0, NULL, NULL);
INSERT INTO `sys_menu`
VALUES (9, 2, '多标签页', 'function_multi-tab', '/function/multi-tab', 'page.(base)_function_multi-tab', '',
        'route.(base)_function_multi-tab', 0, 1, 'ic:round-tab', 1, 0, 0, NULL, 1, 3, '/function/tab', 0,
        '2026-01-04 11:31:54', NULL, 1, NULL, NULL);
INSERT INTO `sys_menu`
VALUES (10, 2, '请求', 'function_request', '/function/request', 'page.(base)_function_request', '',
        'route.(base)_function_request', 3, 1, 'carbon:network-overlay', 1, 0, 0, NULL, 0, 3, NULL, 0,
        '2026-01-04 11:31:54', NULL, 0, NULL, NULL);
INSERT INTO `sys_menu`
VALUES (11, 2, '超级管理员可见', 'function_super-page', '/function/super-page', 'page.(base)_function_super-page', '',
        'route.(base)_function_super-page', 5, 1, 'ic:round-supervisor-account', 1, 0, 0, NULL, 0, 3, NULL, 0,
        '2026-01-04 11:31:54', NULL, 0, NULL, NULL);
INSERT INTO `sys_menu`
VALUES (12, 2, '标签页', 'function_tab', '/function/tab', 'page.(base)_function_tab', '', 'route.(base)_function_tab',
        1, 1, 'ic:round-tab', 1, 1, 0, NULL, 0, 3, NULL, 0, '2026-01-04 11:31:54', NULL, 0, NULL, NULL);
INSERT INTO `sys_menu`
VALUES (13, 2, '切换权限', 'function_toggle-auth', '/function/toggle-auth', 'page.(base)_function_toggle-auth', '',
        'route.(base)_function_toggle-auth', 4, 1, 'ic:round-construction', 1, 0, 0, NULL, 0, 3, NULL, 0,
        '2026-01-04 11:31:54', NULL, 0, NULL, NULL);
INSERT INTO `sys_menu`
VALUES (14, 1, '系统管理', 'manage', '/manage', 'page.(base)_manage', '(base)', 'route.(base)_manage', 8, 1,
        'carbon:cloud-service-management', 1, 0, 0, NULL, 0, 0, NULL, 0, '2026-01-04 11:31:54', NULL, 0, NULL, NULL);
INSERT INTO `sys_menu`
VALUES (15, 2, '用户管理', 'manage_user', '/manage/user', 'page.(base)_manage_user', '', 'route.(base)_manage_user', 4,
        1, 'ic:round-manage-accounts', 1, 1, 0, '', 0, 14, NULL, 0, '2026-01-04 11:31:54', '2026-05-05 18:00:57', 0,
        NULL, '[]');
INSERT INTO `sys_menu`
VALUES (16, 2, '用户详情', 'manage_user_[id]', '/manage/user/:id', 'page.(base)_manage_user_[id]', '',
        'route.(base)_manage_user_[id]', 0, 1, NULL, 1, 0, 0, NULL, 1, 15, '/manage/user', 0, '2026-01-04 11:31:54',
        NULL, 0, NULL, NULL);
INSERT INTO `sys_menu`
VALUES (17, 2, '角色管理', 'manage_role', '/manage/role', 'page.(base)_manage_role', '', 'route.(base)_manage_role', 3,
        1, 'carbon:user-role', 1, 0, 0, '', 0, 14, NULL, 0, '2026-01-04 11:31:54', '2026-05-05 18:00:26', 0, NULL,
        '[]');
INSERT INTO `sys_menu`
VALUES (18, 2, '角色管理详情', 'manage_role_[...slug]', '/manage/role/*', 'page.(base)_manage_role_[...slug]', '',
        'route.(base)_manage_role_[...slug]', 0, 1, NULL, 1, 0, 0, NULL, 1, 17, '/manage/role', 0,
        '2026-01-04 11:31:54', NULL, 0, NULL, NULL);
INSERT INTO `sys_menu`
VALUES (19, 2, '菜单管理', 'manage_menu', '/manage/menu', 'page.(base)_manage_menu', '', 'route.(base)_manage_menu', 1,
        1, 'material-symbols:route', 1, 0, 0, '', 0, 14, NULL, 0, '2026-01-04 11:31:54', '2026-01-05 03:43:43', 0, NULL,
        '[]');
INSERT INTO `sys_menu`
VALUES (20, 1, '多级菜单', 'multi-menu', '/multi-menu', 'page.(base)_multi-menu', '', 'route.(base)_multi-menu', 5, 1,
        'icon-park-outline:one-key', 1, 0, 0, '', 0, 0, NULL, 0, '2026-01-04 11:31:54', '2026-05-07 12:56:14', 0, NULL,
        '[]');
INSERT INTO `sys_menu`
VALUES (21, 1, '菜单一', 'multi-menu_first', '/multi-menu/first', 'page.(base)_multi-menu_first', '',
        'route.(base)_multi-menu_first', 0, 1, 'gg:menu-round', 1, 0, 0, '', 0, 20, NULL, 0, '2026-01-04 11:31:54',
        '2026-05-07 12:57:58', 0, NULL, '[]');
INSERT INTO `sys_menu`
VALUES (22, 2, '菜单一子菜单', 'multi-menu_first_child', '/multi-menu/first/child',
        'page.(base)_multi-menu_first_child', '', 'route.(base)_multi-menu_first_child', 0, 1, 'gg:menu-round', 1, 0, 0,
        '', 0, 21, NULL, 0, '2026-01-04 11:31:54', '2026-05-07 12:58:13', 0, NULL, '[]');
INSERT INTO `sys_menu`
VALUES (23, 1, '菜单二', 'multi-menu_second', '/multi-menu/second', 'page.(base)_multi-menu_second', '',
        'route.(base)_multi-menu_second', 0, 1, 'gg:menu-round', 1, 0, 0, '', 0, 20, NULL, 0, '2026-01-04 11:31:54',
        '2026-05-07 12:58:26', 0, NULL, '[]');
INSERT INTO `sys_menu`
VALUES (24, 1, '菜单二子菜单', 'multi-menu_second_child', '/multi-menu/second/child',
        'page.(base)_multi-menu_second_child', '', 'route.(base)_multi-menu_second_child', 0, 1, 'gg:menu-round', 1, 0,
        0, '', 0, 23, NULL, 0, '2026-01-04 11:31:54', '2026-05-07 12:58:36', 0, NULL, '[]');
INSERT INTO `sys_menu`
VALUES (25, 2, '菜单二子菜单首页', 'multi-menu_second_child_home', '/multi-menu/second/child/home',
        'page.(base)_multi-menu_second_child_home', '', 'route.(base)_multi-menu_second_child_home', 0, 1, NULL, 1, 0,
        0, NULL, 0, 24, NULL, 0, '2026-01-04 11:31:54', NULL, 0, NULL, NULL);
INSERT INTO `sys_menu`
VALUES (26, 1, '多级动态路由', 'projects', '/projects', 'page.(base)_projects', '(base)', 'route.(base)_projects', 7, 1,
        'hugeicons:align-box-top-center', 1, 0, 0, NULL, 0, 0, NULL, 0, '2026-01-04 11:31:54', NULL, 0, NULL, NULL);
INSERT INTO `sys_menu`
VALUES (27, 2, '多级动态路由详情', 'projects_[pid]', '/projects/:pid', 'page.(base)_projects_[pid]', '',
        'route.(base)_projects_[pid]', 0, 1, 'material-symbols-light:attachment', 1, 0, 0, NULL, 0, 26, NULL, 0,
        '2026-01-04 11:31:54', NULL, 0, NULL, NULL);
INSERT INTO `sys_menu`
VALUES (28, 2, '多级动态路由编辑', 'projects_[pid]_edit', '/projects/:pid/edit', 'page.(base)_projects_[pid]_edit', '',
        'route.(base)_projects_[pid]_edit', 0, 1, 'material-symbols-light:assistant-on-hub-outline', 1, 0, 0, NULL, 0,
        27, NULL, 0, '2026-01-04 11:31:54', NULL, 0, NULL, NULL);
INSERT INTO `sys_menu`
VALUES (29, 2, '多级动态路由编辑详情', 'projects_[pid]_edit_[id]', '/projects/:pid/edit/:id',
        'page.(base)_projects_[pid]_edit_[id]', '', 'route.(base)_projects_[pid]_edit_[id]', 0, 1, NULL, 1, 0, 0, NULL,
        0, 28, NULL, 0, '2026-01-04 11:31:54', NULL, 0, NULL, NULL);
INSERT INTO `sys_menu`
VALUES (30, 2, '个人中心', 'user-center', '/user-center', 'page.(base)_user-center', '', 'route.(base)_user-center', 0,
        1, 'uil:user', 1, 0, 0, '', 1, 0, NULL, 0, '2026-01-04 11:31:54', '2026-05-07 10:32:54', 0, NULL, '[]');
INSERT INTO `sys_menu`
VALUES (31, 1, '异常页面', 'exception', '/exception', NULL, '(base)', 'route.exception', 4, 1,
        'ant-design:exception-outlined', 1, 0, 0, NULL, 0, 0, NULL, 0, '2026-01-04 11:31:54', NULL, 0, NULL, NULL);
INSERT INTO `sys_menu`
VALUES (32, 2, '403异常', 'exception_403', '/exception/403', 'page.403', '', 'route.exception_403', 0, 1,
        'ic:baseline-block', 1, 0, 0, NULL, 0, 31, NULL, 0, '2026-01-04 11:31:54', NULL, 0, NULL, NULL);
INSERT INTO `sys_menu`
VALUES (33, 2, '404异常', 'exception_404', '/exception/404', 'page.404', '', 'route.exception_404', 0, 1,
        'nrk:media-404-notfound', 1, 0, 0, '', 0, 31, NULL, 0, '2026-01-04 11:31:54', '2026-05-07 13:03:46', 0, NULL,
        '[]');
INSERT INTO `sys_menu`
VALUES (34, 2, '500异常', 'exception_500', '/exception/500', 'page.500', '', 'route.exception_500', 0, 1,
        'material-symbols:error', 1, 0, 0, '', 0, 31, NULL, 0, '2026-01-04 11:31:54', '2026-05-07 10:35:39', 0, NULL,
        '[]');
INSERT INTO `sys_menu`
VALUES (35, 1, '文档中心', 'document', '/document', NULL, '(base)', 'route.document', 2, 1,
        'mdi:file-document-multiple-outline', 1, 0, 0, NULL, 0, 0, NULL, 0, '2026-01-04 11:31:54', NULL, 0, NULL, NULL);
INSERT INTO `sys_menu`
VALUES (36, 2, 'Ant Design文档', 'document_antd', '/document/antd', 'page.iframe-page', '', 'route.document_antd', 7, 1,
        'logos:ant-design', 1, 0, 0, 'https://ant.design/index-cn', 0, 35, NULL, 0, '2026-01-04 11:31:54', NULL, 0,
        NULL, NULL);
INSERT INTO `sys_menu`
VALUES (37, 2, 'ProComponents文档', 'document_procomponents', '/document/procomponents', 'page.iframe-page', '',
        'route.document_procomponents', 8, 1, 'logos:ant-design', 1, 0, 0, 'https://pro-components.antdigital.dev/', 0,
        35, NULL, 0, '2026-01-04 11:31:54', NULL, 0, NULL, NULL);
INSERT INTO `sys_menu`
VALUES (38, 2, 'UI演示文档', 'document_ui', '/document/ui', 'page.iframe-page', '', 'route.document_ui', 0, 2, 'logo',
        1, 0, 0, 'https://ui-play.skyroc.me/button', 0, 35, NULL, 0, '2026-01-04 11:31:54', NULL, 0, NULL, NULL);
INSERT INTO `sys_menu`
VALUES (39, 2, '项目文档', 'document_project', '/document/project', 'page.iframe-page', '', 'route.document_project', 1,
        2, 'logo', 1, 0, 0, 'https://admin-docs.skyroc.me  ', 0, 35, NULL, 0, '2026-01-04 11:31:54', NULL, 0, NULL,
        NULL);
INSERT INTO `sys_menu`
VALUES (40, 2, '项目文档链接', 'document_project-link', '/document/project-link', 'page.iframe-page', '',
        'route.document_project-link', 2, 2, 'logo', 1, 0, 0, 'https://admin-docs.skyroc.me  ', 0, 35, NULL, 0,
        '2026-01-04 11:31:54', NULL, 0, NULL, NULL);
INSERT INTO `sys_menu`
VALUES (41, 2, 'UnoCSS文档', 'document_unocss', '/document/unocss', 'page.iframe-page', '', 'route.document_unocss', 5,
        1, 'logos:unocss', 1, 0, 0, 'https://unocss.dev/', 0, 35, NULL, 0, '2026-01-04 11:31:54', NULL, 0, NULL, NULL);
INSERT INTO `sys_menu`
VALUES (42, 2, 'Vite文档', 'document_vite', '/document/vite', 'page.iframe-page', '', 'route.document_vite', 4, 1,
        'logos:vitejs', 1, 0, 0, 'https://cn.vitejs.dev/', 0, 35, NULL, 0, '2026-01-04 11:31:54', NULL, 0, NULL, NULL);
INSERT INTO `sys_menu`
VALUES (43, 2, 'React文档', 'document_react', '/document/react', 'page.iframe-page', '', 'route.document_react', 3, 1,
        'logos:react', 1, 0, 0, 'https://react.dev/', 0, 35, NULL, 0, '2026-01-04 11:31:54', NULL, 0, NULL, NULL);
INSERT INTO `sys_menu`
VALUES (44, 2, '按钮管理', 'manage_button', '/manage/button', 'page.(base)_manage_button', NULL,
        'route.(base)_manage_button', 2, 1, 'streamline-sharp-color:buttons-all', 1, 0, 0, '', 0, 14, NULL, 0,
        '2026-05-05 17:50:14', '2026-05-05 15:24:37', 0, NULL, '[]');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`
(
    `role_id`              bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '角色ID（主键）',
    `role_code`            varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NOT NULL COMMENT '角色编码（唯一标识，如：R_SUPER_ADMIN/R_ADMIN/R_GUEST',
    `role_name`            varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色名称（如：超级管理员/管理员/访客）',
    `role_desc`            varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '角色描述',
    `status`               tinyint(0) NOT NULL DEFAULT 1 COMMENT '角色状态（1:正常 2:禁止）',
    `create_time`          datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
    `update_time`          datetime(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
    `deleted`              tinyint(0) NOT NULL DEFAULT 0 COMMENT '逻辑删除：0-未删除 1-已删除',
    `default_home_page_id` bigint(0) NULL DEFAULT NULL COMMENT '默认首页 ID（关联 sys_menu 表）',
    PRIMARY KEY (`role_id`) USING BTREE,
    UNIQUE INDEX `uk_role_code`(`role_code`) USING BTREE COMMENT '角色编码唯一索引',
    INDEX                  `idx_status`(`status`) USING BTREE COMMENT '状态索引（查询常用）',
    INDEX                  `idx_create_time`(`create_time`) USING BTREE COMMENT '创建时间索引',
    INDEX                  `idx_deleted`(`deleted`) USING BTREE COMMENT '逻辑删除索引（查询必带条件）'
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统角色表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role`
VALUES (1, 'R_SUPER_ADMIN', '超级管理员', '系统最高权限，拥有所有功能操作权限', 1, '2026-05-06 16:54:29',
        '2026-05-07 13:42:18', 0, 13);
INSERT INTO `sys_role`
VALUES (2, 'R_ADMIN', '系统管理员', '负责系统日常管理、用户与权限配置', 1, '2026-05-06 16:54:29', '2026-05-07 13:26:40',
        0, 13);
INSERT INTO `sys_role`
VALUES (3, 'R_USER', '普通用户', '基础功能使用权限，无系统管理权限', 1, '2026-05-06 16:54:29', '2026-05-06 11:59:06', 0,
        1);
INSERT INTO `sys_role`
VALUES (4, 'R_GUEST', '访客', '仅可查看公开页面，无任何操作权限', 1, '2026-05-06 16:54:29', NULL, 0, 1);
INSERT INTO `sys_role`
VALUES (5, 'R_FINANCE', '财务人员', '负责财务数据查看、导出、对账操作', 1, '2026-05-06 16:54:29', NULL, 0, 1);
INSERT INTO `sys_role`
VALUES (6, 'R_HR', '人事专员', '负责员工信息、组织架构管理权限', 1, '2026-05-06 16:54:29', NULL, 0, 1);
INSERT INTO `sys_role`
VALUES (7, 'R_OPERATOR', '运营人员', '负责内容管理、数据统计、运营配置操作', 1, '2026-05-06 16:54:29', NULL, 0, 1);
INSERT INTO `sys_role`
VALUES (8, 'R_CUSTOMER', '客服人员', '负责用户咨询、工单处理、客户服务', 1, '2026-05-06 16:54:29', NULL, 0, 1);
INSERT INTO `sys_role`
VALUES (9, 'R_MARKET', '市场人员', '负责营销活动、推广数据查看权限', 1, '2026-05-06 16:54:29', NULL, 0, 1);
INSERT INTO `sys_role`
VALUES (10, 'R_TECH', '技术支持', '负责系统问题排查、技术服务支持', 1, '2026-05-06 16:54:29', NULL, 0, 1);
INSERT INTO `sys_role`
VALUES (11, 'R_PRODUCT', '产品管理员', '负责产品配置、功能开关管理', 1, '2026-05-06 16:54:29', NULL, 0, 1);
INSERT INTO `sys_role`
VALUES (12, 'R_DATA', '数据分析师', '负责数据报表、数据分析、数据导出', 1, '2026-05-06 16:54:29', NULL, 0, 1);
INSERT INTO `sys_role`
VALUES (13, 'R_AUDIT', '审计管理员', '负责日志审计、操作记录查看、安全审计', 1, '2026-05-06 16:54:29', NULL, 0, 1);
INSERT INTO `sys_role`
VALUES (14, 'R_SECURITY', '安全管理员', '负责系统安全配置、权限风险控制', 1, '2026-05-06 16:54:29', NULL, 0, 1);
INSERT INTO `sys_role`
VALUES (15, 'R_TEST', '测试人员', '负责功能测试、数据测试、环境测试', 1, '2026-05-06 16:54:29', NULL, 0, 1);

-- ----------------------------
-- Table structure for sys_role_button
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_button`;
CREATE TABLE `sys_role_button`
(
    `id`        bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `role_id`   bigint(0) UNSIGNED NOT NULL COMMENT '角色ID',
    `button_id` bigint(0) UNSIGNED NOT NULL COMMENT '按钮ID',
    PRIMARY KEY (`id`) USING BTREE,
    INDEX       `idx_role_id`(`role_id`) USING BTREE,
    INDEX       `idx_button_id`(`button_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 95 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色-按钮权限关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_button
-- ----------------------------
INSERT INTO `sys_role_button`
VALUES (71, 1, 25);
INSERT INTO `sys_role_button`
VALUES (72, 1, 7);
INSERT INTO `sys_role_button`
VALUES (73, 1, 8);
INSERT INTO `sys_role_button`
VALUES (74, 1, 9);
INSERT INTO `sys_role_button`
VALUES (75, 1, 10);
INSERT INTO `sys_role_button`
VALUES (76, 1, 16);
INSERT INTO `sys_role_button`
VALUES (77, 1, 17);
INSERT INTO `sys_role_button`
VALUES (78, 1, 18);
INSERT INTO `sys_role_button`
VALUES (79, 1, 19);
INSERT INTO `sys_role_button`
VALUES (80, 1, 20);
INSERT INTO `sys_role_button`
VALUES (81, 1, 21);
INSERT INTO `sys_role_button`
VALUES (82, 1, 22);
INSERT INTO `sys_role_button`
VALUES (83, 1, 23);
INSERT INTO `sys_role_button`
VALUES (84, 1, 24);
INSERT INTO `sys_role_button`
VALUES (85, 1, 11);
INSERT INTO `sys_role_button`
VALUES (86, 1, 12);
INSERT INTO `sys_role_button`
VALUES (87, 1, 13);
INSERT INTO `sys_role_button`
VALUES (88, 1, 14);
INSERT INTO `sys_role_button`
VALUES (89, 1, 15);
INSERT INTO `sys_role_button`
VALUES (90, 1, 26);
INSERT INTO `sys_role_button`
VALUES (91, 1, 27);
INSERT INTO `sys_role_button`
VALUES (92, 2, 26);
INSERT INTO `sys_role_button`
VALUES (93, 2, 27);
INSERT INTO `sys_role_button`
VALUES (94, 3, 27);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`
(
    `id`      bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `role_id` bigint(0) NOT NULL COMMENT '角色ID',
    `menu_id` bigint(0) NOT NULL COMMENT '菜单ID',
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `uk_role_menu`(`role_id`, `menu_id`) USING BTREE COMMENT '角色+菜单唯一索引，避免重复绑定',
    INDEX     `idx_role_id`(`role_id`) USING BTREE COMMENT '角色ID索引，提升查询效率',
    INDEX     `idx_menu_id`(`menu_id`) USING BTREE COMMENT '菜单ID索引，提升查询效率'
) ENGINE = InnoDB AUTO_INCREMENT = 462 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色菜单关联中间表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu`
VALUES (341, 1, 1);
INSERT INTO `sys_role_menu`
VALUES (342, 1, 2);
INSERT INTO `sys_role_menu`
VALUES (343, 1, 3);
INSERT INTO `sys_role_menu`
VALUES (344, 1, 4);
INSERT INTO `sys_role_menu`
VALUES (345, 1, 5);
INSERT INTO `sys_role_menu`
VALUES (346, 1, 6);
INSERT INTO `sys_role_menu`
VALUES (347, 1, 7);
INSERT INTO `sys_role_menu`
VALUES (348, 1, 8);
INSERT INTO `sys_role_menu`
VALUES (349, 1, 9);
INSERT INTO `sys_role_menu`
VALUES (350, 1, 10);
INSERT INTO `sys_role_menu`
VALUES (351, 1, 11);
INSERT INTO `sys_role_menu`
VALUES (352, 1, 12);
INSERT INTO `sys_role_menu`
VALUES (353, 1, 13);
INSERT INTO `sys_role_menu`
VALUES (354, 1, 14);
INSERT INTO `sys_role_menu`
VALUES (355, 1, 15);
INSERT INTO `sys_role_menu`
VALUES (356, 1, 16);
INSERT INTO `sys_role_menu`
VALUES (357, 1, 17);
INSERT INTO `sys_role_menu`
VALUES (358, 1, 18);
INSERT INTO `sys_role_menu`
VALUES (359, 1, 19);
INSERT INTO `sys_role_menu`
VALUES (360, 1, 20);
INSERT INTO `sys_role_menu`
VALUES (361, 1, 21);
INSERT INTO `sys_role_menu`
VALUES (362, 1, 22);
INSERT INTO `sys_role_menu`
VALUES (363, 1, 23);
INSERT INTO `sys_role_menu`
VALUES (364, 1, 24);
INSERT INTO `sys_role_menu`
VALUES (365, 1, 25);
INSERT INTO `sys_role_menu`
VALUES (366, 1, 26);
INSERT INTO `sys_role_menu`
VALUES (367, 1, 27);
INSERT INTO `sys_role_menu`
VALUES (368, 1, 28);
INSERT INTO `sys_role_menu`
VALUES (369, 1, 29);
INSERT INTO `sys_role_menu`
VALUES (370, 1, 30);
INSERT INTO `sys_role_menu`
VALUES (371, 1, 31);
INSERT INTO `sys_role_menu`
VALUES (372, 1, 32);
INSERT INTO `sys_role_menu`
VALUES (373, 1, 33);
INSERT INTO `sys_role_menu`
VALUES (374, 1, 34);
INSERT INTO `sys_role_menu`
VALUES (375, 1, 35);
INSERT INTO `sys_role_menu`
VALUES (376, 1, 36);
INSERT INTO `sys_role_menu`
VALUES (377, 1, 37);
INSERT INTO `sys_role_menu`
VALUES (378, 1, 38);
INSERT INTO `sys_role_menu`
VALUES (379, 1, 39);
INSERT INTO `sys_role_menu`
VALUES (380, 1, 40);
INSERT INTO `sys_role_menu`
VALUES (381, 1, 41);
INSERT INTO `sys_role_menu`
VALUES (382, 1, 42);
INSERT INTO `sys_role_menu`
VALUES (383, 1, 43);
INSERT INTO `sys_role_menu`
VALUES (384, 1, 44);
INSERT INTO `sys_role_menu`
VALUES (426, 2, 1);
INSERT INTO `sys_role_menu`
VALUES (427, 2, 2);
INSERT INTO `sys_role_menu`
VALUES (428, 2, 4);
INSERT INTO `sys_role_menu`
VALUES (429, 2, 5);
INSERT INTO `sys_role_menu`
VALUES (430, 2, 6);
INSERT INTO `sys_role_menu`
VALUES (431, 2, 7);
INSERT INTO `sys_role_menu`
VALUES (432, 2, 8);
INSERT INTO `sys_role_menu`
VALUES (433, 2, 9);
INSERT INTO `sys_role_menu`
VALUES (434, 2, 10);
INSERT INTO `sys_role_menu`
VALUES (435, 2, 12);
INSERT INTO `sys_role_menu`
VALUES (436, 2, 13);
INSERT INTO `sys_role_menu`
VALUES (437, 2, 20);
INSERT INTO `sys_role_menu`
VALUES (438, 2, 21);
INSERT INTO `sys_role_menu`
VALUES (439, 2, 22);
INSERT INTO `sys_role_menu`
VALUES (440, 2, 23);
INSERT INTO `sys_role_menu`
VALUES (441, 2, 24);
INSERT INTO `sys_role_menu`
VALUES (442, 2, 25);
INSERT INTO `sys_role_menu`
VALUES (443, 2, 26);
INSERT INTO `sys_role_menu`
VALUES (444, 2, 27);
INSERT INTO `sys_role_menu`
VALUES (445, 2, 28);
INSERT INTO `sys_role_menu`
VALUES (446, 2, 29);
INSERT INTO `sys_role_menu`
VALUES (447, 2, 30);
INSERT INTO `sys_role_menu`
VALUES (448, 2, 31);
INSERT INTO `sys_role_menu`
VALUES (449, 2, 32);
INSERT INTO `sys_role_menu`
VALUES (450, 2, 33);
INSERT INTO `sys_role_menu`
VALUES (451, 2, 34);
INSERT INTO `sys_role_menu`
VALUES (452, 2, 35);
INSERT INTO `sys_role_menu`
VALUES (453, 2, 36);
INSERT INTO `sys_role_menu`
VALUES (454, 2, 37);
INSERT INTO `sys_role_menu`
VALUES (455, 2, 38);
INSERT INTO `sys_role_menu`
VALUES (456, 2, 39);
INSERT INTO `sys_role_menu`
VALUES (457, 2, 40);
INSERT INTO `sys_role_menu`
VALUES (458, 2, 41);
INSERT INTO `sys_role_menu`
VALUES (459, 2, 42);
INSERT INTO `sys_role_menu`
VALUES (460, 2, 43);
INSERT INTO `sys_role_menu`
VALUES (461, 2, 44);
INSERT INTO `sys_role_menu`
VALUES (423, 3, 1);
INSERT INTO `sys_role_menu`
VALUES (424, 3, 13);
INSERT INTO `sys_role_menu`
VALUES (425, 3, 30);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`
(
    `id`      bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `user_id` bigint(0) UNSIGNED NOT NULL COMMENT '用户ID（关联system_user.user_id）',
    `role_id` bigint(0) UNSIGNED NOT NULL COMMENT '角色ID（关联sys_role.role_id）',
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `uk_user_role`(`user_id`, `role_id`) USING BTREE COMMENT '用户+角色唯一索引（避免重复绑定）',
    INDEX     `idx_role_id`(`role_id`) USING BTREE COMMENT '角色ID索引（查询角色下用户常用）'
) ENGINE = InnoDB AUTO_INCREMENT = 38 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户角色关联表（多对多）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role`
VALUES (37, 1, 1);
INSERT INTO `sys_user_role`
VALUES (34, 17, 2);
INSERT INTO `sys_user_role`
VALUES (36, 18, 3);

-- ----------------------------
-- Table structure for system_user
-- ----------------------------
DROP TABLE IF EXISTS `system_user`;
CREATE TABLE `system_user`
(
    `user_id`     bigint(0) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户Id',
    `user_name`   varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci  NOT NULL COMMENT '用户名（唯一）',
    `password`    varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '登录密码(pzh18785384970@)',
    `user_nick`   varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户昵称',
    `avatar`      varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像',
    `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
    `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
    `user_gender` tinyint(0) NULL DEFAULT NULL COMMENT '用户性别(1:男 2:女)',
    `user_email`  varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户邮箱',
    `user_phone`  varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户手机号',
    `status`      tinyint(0) NOT NULL DEFAULT 1 COMMENT '用户状态（1:正常 2:禁止）',
    PRIMARY KEY (`user_id`) USING BTREE,
    UNIQUE INDEX `uk_user_name`(`user_name`) USING BTREE COMMENT '用户名(唯一索引)',
    UNIQUE INDEX `uk_user_email`(`user_email`) USING BTREE COMMENT '邮箱(唯一索引)',
    UNIQUE INDEX `uk_user_phone`(`user_phone`) USING BTREE COMMENT '手机号(唯一索引)'
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_user
-- ----------------------------
INSERT INTO `system_user`
VALUES (1, 'super', 'PBKDF2WithHmacSHA256$100000$OquGiABu04/uigirXEGQuQ==$k37XYUa2AqNfe51J6q/QYEA1r/yd0rtONHDF891jpik=',
        '超级管理员',
        'https://smallhui-1300189124.cos.ap-chongqing.myqcloud.com/uploads/00ef4e81-e338-4adf-8fb9-9b318064a052.jpg',
        '2025-12-31 19:59:53', '2026-05-07 13:56:16', 1, '1939673715@qq.com', '18785384970', 1);
INSERT INTO `system_user`
VALUES (17, 'admin',
        'PBKDF2WithHmacSHA256$100000$UKDvpu24SxSoKvI4OzrMqQ==$J5GT8zIDD0hlZO9bYU1fpYXX/j/4R8tOvQ8NVEsaScE=', '管理员',
        'https://smallhui-1300189124.cos.ap-chongqing.myqcloud.com/uploads/a3ca6705-454c-4fc1-afa4-4e8953f2b79e.png',
        '2026-05-06 11:34:15', '2026-05-06 11:35:37', 1, 'pzh1939673715@gmail.com', '18785384971', 1);
INSERT INTO `system_user`
VALUES (18, 'user', 'PBKDF2WithHmacSHA256$100000$K42x0H/7djCwLBKCD0BQwg==$bdVxCShTuHviXB1ge9aIcChpIRe7e96orx/gbw1Gp/4=',
        '用户',
        'https://smallhui-1300189124.cos.ap-chongqing.myqcloud.com/uploads/e46be011-8156-4ebb-b32f-c52f74002352.jpg',
        '2026-05-06 11:37:18', '2026-05-06 11:37:18', 1, '18785384972@qq.com', '18785384972', 1);
INSERT INTO `system_user`
VALUES (19, 'wang', 'PBKDF2WithHmacSHA256$100000$9ADLO1F9/cY4vBpIFocxwA==$+CtQihQ5JqiaOXGlf3zEOu4laurwe2tV9P1FIJkmd2s=',
        '小王',
        'https://smallhui-1300189124.cos.ap-chongqing.myqcloud.com/uploads/975f0e95-c3b0-4292-b9f9-9a12ed0cc2db.png',
        '2026-05-06 14:28:51', '2026-05-06 14:28:51', 1, 'xxx1939673715@gmail.com', '18785384978', 1);
INSERT INTO `system_user`
VALUES (20, 'test', 'PBKDF2WithHmacSHA256$100000$Ube6UKaRXFHYpMNNEgf29Q==$kaZno9V11bQ2FQxj4HoozXuMe5vRyhXjh2408AI8LoE=',
        '测试员',
        'https://smallhui-1300189124.cos.ap-chongqing.myqcloud.com/uploads/cae11b6c-0756-4948-a068-c044bb59eb21.jpg',
        '2026-05-07 05:54:35', '2026-05-07 06:55:27', 1, 'ccc1939673715@gmail.com', '13385385679', 1);

SET
FOREIGN_KEY_CHECKS = 1;
