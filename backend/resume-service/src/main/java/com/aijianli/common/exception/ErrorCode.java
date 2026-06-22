package com.aijianli.common.exception;

import lombok.Getter;

@Getter
public enum ErrorCode {

    PARAM_ERROR(400, "请求参数错误"),
    UNAUTHORIZED(401, "未登录或登录已失效"),
    FORBIDDEN(403, "无权限访问该资源"),
    NOT_FOUND(404, "资源不存在"),
    UPLOAD_ERROR(4101, "文件上传失败"),
    RESUME_PARSE_ERROR(4102, "简历解析失败"),
    AI_REQUEST_ERROR(4201, "AI 服务调用失败"),
    SYSTEM_ERROR(500, "系统繁忙，请稍后重试");

    private final int code;
    private final String message;

    ErrorCode(int code, String message) {
        this.code = code;
        this.message = message;
    }
}
