package cn.pzhdv.skyrocadminapi.controller;


import cn.pzhdv.skyrocadminapi.config.FileSizeConfig;
import cn.pzhdv.skyrocadminapi.vo.file.UploadResultVO;
import cn.pzhdv.skyrocadminapi.exception.FileValidationException;
import cn.pzhdv.skyrocadminapi.result.Result;
import cn.pzhdv.skyrocadminapi.result.ResultCode;
import cn.pzhdv.skyrocadminapi.result.ResultUtil;
import com.qcloud.cos.COSClient;
import com.qcloud.cos.model.ObjectMetadata;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import lombok.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * <p>
 * 文件上传 前端控制器
 * </p>
 *
 * @author PanZonghui
 * @version 1.0
 * @since 2025-12-31
 */
@Slf4j
@Api(tags = "文件上传")
@RestController
@RequestMapping("upload")
@RequiredArgsConstructor
public class FileUploadController {
    // 上传目录常量：确保以斜杠结尾，避免URL拼接缺失分隔符
    private static final String UPLOADS_DIRECTORY = "uploads/";

    // 依赖注入：final字段会被@RequiredArgsConstructor纳入构造函数
    private final COSClient cosClient;
    private final FileSizeConfig fileSizeConfig;

    // 从配置文件注入COS相关参数（非final，通过@Value注入）
    @Value("${tencent.cos.bucketName}")
    private String bucketName;

    @Value("${tencent.cos.baseUrl:}")
    private String cosBaseUrl;

    @PostMapping(value = "single", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @ApiOperation(value = "单文件上传接口", notes = "上传单个文件，支持图片、文档等，大小限制以配置为准", httpMethod = "POST")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "file", value = "上传的文件", paramType = "formData",
                    dataType = "MultipartFile", dataTypeClass = MultipartFile.class, required = true),
    })
    public Result<UploadResultVO> uploadSingle(@RequestPart("file") MultipartFile file) {
        // 前置校验：文件为空直接返回标准错误码
        if (file == null || file.isEmpty()) {
            return ResultUtil.error(ResultCode.FILE_NULL_ERROR);
        }
        UploadResultVO result = upload(file);
        return ResultUtil.ok(result);
    }


    @PostMapping(value = "batch", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @ApiOperation(value = "多文件上传接口", notes = "批量上传多个文件，大小限制以配置为准", httpMethod = "POST")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "files", value = "文件列表(支持多选)", paramType = "formData",
                    dataType = "MultipartFile", dataTypeClass = MultipartFile.class,
                    collectionFormat = "array", required = true),
    })
    public Result<List<UploadResultVO>> uploadBatch(@RequestPart("files") MultipartFile[] files) {
        // 1. 校验文件数组为空
        if (files == null || files.length == 0) {
            return ResultUtil.error(ResultCode.FILE_NULL_ERROR);
        }


        // 2. 计算总大小并校验（使用动态配置的总大小限制）
        long totalSize = Arrays.stream(files)
                .mapToLong(file -> (file == null || file.isEmpty()) ? 0 : file.getSize())
                .sum();
        // 总文件超限判断
        if (totalSize > fileSizeConfig.getTotalMaxSizeBytes()) {
            // 传递配置的总最大大小（转MB）
            String maxTotalSizeMB = String.format("%.1fMB", fileSizeConfig.getTotalMaxSizeBytes() / 1024.0 / 1024.0);
            return ResultUtil.error(ResultCode.FILE_TOTAL_MAX_ERROR, ResultCode.FILE_TOTAL_MAX_ERROR.message(maxTotalSizeMB));
        }

        // 3. 并行批量上传（过滤空文件）
        List<UploadResultVO> results = Arrays.stream(files)
                .parallel()
                .map(file -> {
                    if (file == null || file.isEmpty()) {
                        return UploadResultVO.failure(null, 0L, "文件为空，跳过上传");
                    }
                    return safeUpload(file);
                })
                .collect(Collectors.toList());

        return ResultUtil.ok(results);
    }

    /**
     * 核心上传逻辑：处理单个文件的COS上传
     */
    private UploadResultVO upload(MultipartFile file) {
        // 1. 先执行文件校验（大小、类型、流有效性）
        validateFile(file);
        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null) {
            return UploadResultVO.failure(null, file.getSize(), "文件名获取失败");
        }

        // 2. 生成唯一ObjectKey（避免文件名重复，确保目录分隔符正确）
        String extension = getFileExtension(originalFilename);
        String objectKey = UPLOADS_DIRECTORY + UUID.randomUUID() + extension;

        try (InputStream inputStream = file.getInputStream()) {
            // 3. 配置COS文件元数据（指定文件大小，避免COS自动检测异常）
            ObjectMetadata metadata = new ObjectMetadata();
            metadata.setContentLength(file.getSize());
            // 可选：设置文件MIME类型，优化前端预览体验
            metadata.setContentType(file.getContentType());

            // 4. 执行COS上传
            cosClient.putObject(bucketName, objectKey, inputStream, metadata);

            // 5. 构建正确的访问URL（修复拼写错误风险）
            String fileUrl = buildFileUrl(objectKey);
            return UploadResultVO.success(originalFilename, fileUrl, file.getSize());

        } catch (Exception e) {
            log.error("文件[{}]上传COS失败", originalFilename, e);
            return UploadResultVO.failure(originalFilename, file.getSize(), "COS上传异常：" + e.getMessage());
        }
    }

    /**
     * 安全上传包装：捕获异常转为失败结果，避免并行流中断
     */
    private UploadResultVO safeUpload(MultipartFile file) {
        try {
            return upload(file);
        } catch (FileValidationException e) {
            // 业务校验异常：返回具体错误信息
            log.warn("文件[{}]校验失败", file.getOriginalFilename(), e);
            return UploadResultVO.failure(file.getOriginalFilename(), file.getSize(), e.getMessage());
        } catch (Exception e) {
            // 其他异常：统一返回处理失败
            log.error("文件[{}]处理异常", file.getOriginalFilename(), e);
            return UploadResultVO.failure(file.getOriginalFilename(), file.getSize(), "文件处理失败：" + e.getMessage());
        }
    }

    /**
     * 构建文件访问URL：修复URL拼写错误，确保格式正确
     */
    private String buildFileUrl(String objectKey) {
        // 场景1：使用自定义基础URL（优先，避免默认URL拼写问题）
        if (StringUtils.hasText(cosBaseUrl)) {
            // 确保基础URL以斜杠结尾，避免拼接为 "https://cos.pzhdv.cnuploads/xxx"
            String baseUrl = cosBaseUrl.endsWith("/") ? cosBaseUrl : cosBaseUrl + "/";
            // 确保ObjectKey不重复带斜杠，避免URL多斜杠问题
            objectKey = objectKey.startsWith("/") ? objectKey.substring(1) : objectKey;
            return baseUrl + objectKey;
        }

        // 场景2：使用COS默认URL（从客户端配置获取区域，避免硬编码区域拼写错误）
        String regionName = cosClient.getClientConfig().getRegion().getRegionName();
        // 标准COS URL格式：https://bucketName.cos.region.myqcloud.com/objectKey
        return String.format("https://%s.cos.%s.myqcloud.com/%s", bucketName, regionName, objectKey);
    }

    /**
     * 文件校验：整合所有业务校验规则
     */
    private void validateFile(MultipartFile file) {
        // 1. 校验文件大小（使用动态配置，避免硬编码）
        long fileSize = file.getSize();
        long maxSingleSize = fileSizeConfig.getMaxFileSizeBytes();
        if (fileSize > maxSingleSize) {
            // 1. 将字节转为MB（保留1位小数，用户更易理解）
            String maxSizeMB = String.format("%.1fMB", maxSingleSize / 1024.0 / 1024.0);
            // 2. 传递动态参数maxSizeMB到ResultCode
            throw new FileValidationException(ResultCode.FILE_TOO_LARGE, maxSizeMB);
        }

        // 2. 校验文件类型（确保有后缀名，避免无类型文件上传）
        String originalFilename = file.getOriginalFilename();
        if (originalFilename != null && !originalFilename.contains(".")) {
            throw new FileValidationException(ResultCode.UNSUPPORTED_FILE_TYPE, "无后缀名文件");
        }

        // 3. 校验文件流有效性（避免空流文件）
        try {
            if (file.getInputStream().available() <= 0) {
                throw new FileValidationException(ResultCode.FILE_UPLOAD_FAIL, "文件流为空，无法上传");
            }
        } catch (Exception e) {
            throw new FileValidationException(ResultCode.FILE_UPLOAD_FAIL, "文件流读取异常：" + e.getMessage());
        }
    }

    /**
     * 工具方法：获取文件后缀名（含小数点，如.jpg）
     */
    private String getFileExtension(String filename) {
        int lastDotIndex = filename.lastIndexOf('.');
        return lastDotIndex > 0 ? filename.substring(lastDotIndex) : "";
    }


}
