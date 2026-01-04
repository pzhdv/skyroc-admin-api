package cn.pzhdv.skyrocadminapi.utils;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import io.jsonwebtoken.security.SignatureException;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;
import org.springframework.util.Assert;

import javax.crypto.SecretKey;
import javax.servlet.http.HttpServletRequest;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

/**
 * JWT工具类，负责Token的生成、验证和解析
 * 遵循JWT规范实现，支持访问令牌和刷新令牌机制
 */
@Slf4j
@Component
@Data
@ConfigurationProperties(prefix = "jwt")
public class JwtTokenUtil {

    /**
     * Token请求头名称
     */
    private String header;

    /**
     * 签名密钥
     */
    private String tokenSignKey;

    /**
     * 访问令牌有效期(秒)
     */
    private Integer accessTokenExpire;

    /**
     * 刷新令牌有效期(秒)
     */
    private Integer refreshTokenExpire;


    /**
     * 生成访问令牌
     *
     * @param userId 用户ID
     * @return 访问令牌字符串
     */
    public String generateAccessToken(String userId) {
        return generateToken(userId, accessTokenExpire);
    }

    /**
     * 生成刷新令牌
     *
     * @param userId 用户ID
     * @return 刷新令牌字符串
     */
    public String generateRefreshToken(String userId) {
        return generateToken(userId, refreshTokenExpire);
    }

    /**
     * 生成JWT令牌
     *
     * @param userId 用户ID
     * @param expire 有效期(秒)
     * @return JWT令牌字符串
     */
    private String generateToken(String userId, long expire) {
        Assert.hasText(userId, "用户ID不能为空");
        Assert.isTrue(expire > 0, "有效期必须大于0");

        // 创建自定义声明
        Map<String, Object> claims = new HashMap<>(1);
        claims.put("userId", userId);

        // 计算过期时间
        Date expiration = new Date(System.currentTimeMillis() + expire * 1000L);

        // 生成签名密钥
        SecretKey secretKey = getSecretKey();

        // 构建并返回JWT令牌
        String token = Jwts.builder()
                .setClaims(claims)
                .setSubject(userId)
                .setIssuedAt(new Date())
                .setExpiration(expiration)
                .signWith(secretKey, SignatureAlgorithm.HS256)
                .compact();

        log.debug("为用户[{}]生成JWT令牌: {}", userId, token);
        return token;
    }

    /**
     * 验证访问令牌
     *
     * @param token 访问令牌
     * @return 验证结果(true : 有效, false : 无效)
     */
    public boolean validateAccessToken(String token) {
        return validateToken(token);
    }

    /**
     * 验证刷新令牌
     *
     * @param refreshToken 刷新令牌
     * @return 验证结果(true : 有效, false : 无效)
     */
    public boolean validateRefreshToken(String refreshToken) {
        return validateToken(refreshToken);
    }

    /**
     * 验证令牌有效性
     *
     * @param token 令牌
     * @return 验证结果(true : 有效, false : 无效)
     */
    private boolean validateToken(String token) {
        try {
            // 先尝试解析token，如果解析失败会抛出异常
            Claims claims = getAllClaimsFromToken(token);
            
            // 解析成功后再检查是否过期
            Date expiration = claims.getExpiration();
            if (expiration == null) {
                log.warn("JWT令牌缺少过期时间");
                return false;
            }
            
            // 如果未过期，则视为有效
            return !expiration.before(new Date());
        } catch (ExpiredJwtException e) {
            log.warn("JWT令牌已过期: {}", e.getMessage());
        } catch (SignatureException e) {
            log.warn("JWT签名验证失败: {}", e.getMessage());
        } catch (MalformedJwtException e) {
            log.warn("JWT令牌格式错误: {}", e.getMessage());
        } catch (InvalidClaimException e) {
            log.warn("JWT声明无效: {}", e.getMessage());
        } catch (JwtException | IllegalArgumentException e) {
            log.error("JWT令牌验证失败: {}", e.getMessage());
        }
        return false;
    }

    /**
     * 从访问令牌中获取用户ID
     *
     * @param token 访问令牌
     * @return 用户ID
     */
    public String getUserIdFromAccessToken(String token) {
        return getUserIdFromToken(token);
    }

    /**
     * 从刷新令牌中获取用户ID
     *
     * @param refreshToken 刷新令牌
     * @return 用户ID
     */
    public String getUserIdFromRefreshToken(String refreshToken) {
        return getUserIdFromToken(refreshToken);
    }

    /**
     * 从令牌中获取用户ID
     *
     * @param token 令牌
     * @return 用户ID
     */
    private String getUserIdFromToken(String token) {
        return getClaimFromToken(token, claims -> claims.get("userId", String.class));
    }

    /**
     * 从令牌中获取指定声明
     *
     * @param token          令牌
     * @param claimsResolver 声明解析器
     * @param <T>            声明类型
     * @return 声明值
     */
    private <T> T getClaimFromToken(String token, Function<Claims, T> claimsResolver) {
        try {
            Claims claims = getAllClaimsFromToken(token);
            return claimsResolver.apply(claims);
        } catch (Exception e) {
            log.error("从JWT令牌获取声明失败: {}", e.getMessage());
            return null;
        }
    }

    /**
     * 从令牌中获取所有声明
     *
     * @param token 令牌
     * @return 声明集合
     */
    private Claims getAllClaimsFromToken(String token) {
        Assert.hasText(token, "令牌不能为空");
        return Jwts.parserBuilder()
                .setSigningKey(getSecretKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    /**
     * 获取签名密钥
     *
     * @return 签名密钥
     */
    private SecretKey getSecretKey() {
        // 使用UTF-8编码确保密钥一致性
        return Keys.hmacShaKeyFor(tokenSignKey.getBytes(StandardCharsets.UTF_8));
    }

    /**
     * 获取访问密钥过期时间 (单位：秒)
     * @return 失效时间
     */
    public Integer getAccessTokenExpireSeconds() {
        return accessTokenExpire;
    }

    /**
     * 从请求头中提取JWT令牌
     * 格式要求：Authorization: Bearer {token}
     * 
     * @param request HTTP请求对象
     * @return JWT令牌字符串，未找到则返回null
     */
    public String extractTokenFromRequest(HttpServletRequest request) {
        String authHeader = request.getHeader(this.header);
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            return authHeader.substring(7); // 去除"Bearer "前缀  "Bearer ".length() == 7
        }
        return null;
    }
}
