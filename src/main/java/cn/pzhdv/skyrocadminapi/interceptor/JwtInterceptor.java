package cn.pzhdv.skyrocadminapi.interceptor;


import cn.pzhdv.skyrocadminapi.result.ResultCode;
import cn.pzhdv.skyrocadminapi.result.ResultUtil;
import cn.pzhdv.skyrocadminapi.utils.IpUtils;
import cn.pzhdv.skyrocadminapi.utils.JwtTokenUtil;
import cn.pzhdv.skyrocadminapi.utils.ResponseUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * JWT令牌认证拦截器
 * <p>
 * 核心作用：拦截所有需要认证的接口请求，校验请求头中的JWT令牌有效性，
 * 确保只有携带有效令牌的请求才能访问受保护的接口，未通过校验则直接返回认证失败结果。
 * <p>
 * 拦截流程：
 * 1. 记录请求基础信息（路径、客户端IP）；
 * 2. 提取请求头中的JWT令牌；
 * 3. 校验令牌是否存在、是否有效（未过期、签名合法）；
 * 4. 校验通过则放行请求，失败则返回对应错误码并终止请求。
 *
 * @author PanZonghui
 * @version 1.0
 * @since 2025-12-31
 */
@Slf4j
@Component
public class JwtInterceptor implements HandlerInterceptor {

  @Autowired private JwtTokenUtil jwtTokenUtil;

  @Override
  public boolean preHandle(
      HttpServletRequest request, HttpServletResponse response, Object handler) {
    // 用户访问请求记录
    String requestUri = request.getRequestURI();
    String clientIp = IpUtils.getClientIpForLog(request);
    log.info("拦截请求 - 路径：{}，客户端IP：{}", requestUri, clientIp);

    // 1. 提取请求头中的Token
    String token = jwtTokenUtil.extractTokenFromRequest(request);

    // 2. Token不存在校验
    if (!StringUtils.hasText(token)) {
      log.warn("Token验证失败 - 未携带令牌，路径：{}，IP：{}", requestUri, clientIp);
      ResponseUtil.out(response, ResultUtil.error(ResultCode.NOT_LOGIN));
      return false;
    }

    // 3. Token有效性校验
    boolean validateAccessToken = jwtTokenUtil.validateAccessToken(token);
    log.debug("validateAccessToken:{}", validateAccessToken);
    if (!validateAccessToken) {
      log.warn("Token验证失败 - 令牌无效或已过期，路径：{}，IP：{}", requestUri, clientIp);
      ResponseUtil.out(response, ResultUtil.error(ResultCode.TOKEN_EXPIRED));
      return false;
    }

    // 4. 验证通过
    log.info("Token验证成功 - 路径：{}，IP：{}", requestUri, clientIp);
    return true;
  }
}
