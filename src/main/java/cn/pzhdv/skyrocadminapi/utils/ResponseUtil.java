package cn.pzhdv.skyrocadminapi.utils;

import cn.pzhdv.skyrocadminapi.result.Result;
import lombok.extern.slf4j.Slf4j;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @author PanZonghui
 * @since 2025-06-25 13:10:16
 * @Version: 1.0
 * @Description
 */
@Slf4j
public class ResponseUtil {
    public static void out(HttpServletResponse response, Result result) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=utf-8");
        String json = JsonUtils.objectToJson(result);
        ServletOutputStream outputStream = null;
        try {
            outputStream = response.getOutputStream();
            outputStream.write(json.getBytes());
            outputStream.flush();
            outputStream.close();
        } catch (IOException e) {
            log.error(e.getMessage(), e);
        } finally {
            if (outputStream != null) {
                try {
                    outputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
