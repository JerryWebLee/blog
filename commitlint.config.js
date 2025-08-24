export default {
  extends: ["@commitlint/config-conventional"],
  rules: {
    "type-enum": [
      2,
      "always",
      [
        "feat", // 新功能
        "fix", // 修复bug
        "docs", // 文档更新
        "style", // 代码格式调整
        "refactor", // 重构
        "perf", // 性能优化
        "test", // 测试相关
        "chore", // 构建过程或辅助工具的变动
        "ci", // CI/CD相关
        "build", // 构建相关
        "revert", // 回滚
      ],
    ],
    "subject-case": [0], // 不限制主题大小写
    "subject-empty": [2, "never"], // 主题不能为空
    "subject-full-stop": [2, "never", "."], // 主题不能以点结尾
    "header-max-length": [2, "always", 72], // 头部最大长度
    "body-leading-blank": [2, "always"], // body前空行
    "footer-leading-blank": [2, "always"], // footer前空行
  },
};
