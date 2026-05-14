package cn.pzhdv.skyrocadminapi.constant;

/**
 * @author PanZonghui
 * @version 1.0
 * @since 2025-12-31
 */
public class RedisKey {

  // 缓存过期时间：基础值（30分钟）+ 随机偏移量（0-10分钟），单位：秒
  public static final int BASE_EXPIRE_SECONDS = 30 * 60; // 基础30分钟
  public static final int RANDOM_EXPIRE_SECONDS = 10 * 60; // 随机0-10分钟

  /** 系统用户相关的key */
  public static final String SYSTEM_USER_DETAIL_KEY = "system:user:detail:";
  public static final String SYSTEM_USER_PAGE_KEY = "system:user:page:";
  public static final String SYSTEM_USER_USERNAME_EXISTS_KEY = "system:user:username:exists:";
  public static final String SYSTEM_USER_EMAIL_EXISTS_KEY = "system:user:email:exists:";
  public static final String SYSTEM_USER_PHONE_EXISTS_KEY = "system:user:phone:exists:";

  /** 系统角色相关的key */
  public static final String SYS_ROLE_PAGE_KEY = "sys:role:page:";
  public static final String SYS_ROLE_ALL_KEY = "sys:role:all";
  public static final String SYS_ROLE_CODE_EXISTS_KEY = "sys:role:code:exists:";


  /** 系统按钮权限相关的key */
  public static final String SYS_BUTTON_PAGE_KEY = "sys:button:page:";
  public static final String SYS_BUTTON_LIST_KEY = "sys:button:list:";
  public static final String SYS_BUTTON_DETAIL_KEY = "sys:button:detail:";
  public static final String SYS_BUTTON_CODE_EXISTS_KEY = "sys:button:code:exists:";

  /** 系统菜单相关的key */
  public static final String SYS_MENU_PAGE_KEY = "sys:menu:page:";
  public static final String SYS_MENU_TREE_KEY = "sys:menu:tree";
  public static final String SYS_MENU_ALL_PAGES_KEY = "sys:menu:all_pages";
  public static final String SYS_MENU_DETAIL_KEY = "sys:menu:detail:";
}
