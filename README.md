# ZZClang-format
根据现有Xcode10的结构，编写的Xcode10代码格式化工具。应该9也可以，具体未测试。

怀念当年Clang-format的同学，可以用起来。
![Focus](https://github.com/V5zhou/ZZClang-format/blob/master/ZZClang-format/FocusFile%E6%A0%BC%E5%BC%8F%E5%8C%96.gif)

## 安装方法

下载ZZClang-format，直接运行one_key_install，so easy。

## one_key_install为您做了什么？

1. 添加`.clang-format`配置文件到个人文件夹`~`，clang-format脚本的规则配置在这里，当然您可以个性化配置，参考[这里](http://clang.llvm.org/docs/ClangFormatStyleOptions.html)
2. 检查并添加Xcode的UUID
3. 编译插件
4. 检查您的gem源，统一修改为最新https://gems.ruby-china.com/
5. 检查update_xcode_plugins是否安装，未安装则安装
6. 执行unsign

执行过后，您就可以在Xcode->Edit栏中看到ZZClang-format了。

## 功能介绍

ZZClang-format包含下面功能：

1. 格式化当前Focus窗口：FocusFile
2. 格式化多个选中文件：SelectFiles
3. 格式化当前选中文本区域：SelectText
4. 配置是否save时格式化：ZZFormatOnSave

## 额外配置
您可以配置快捷键，用起来更方便。
例如，为FocusFile添加快捷键：

> 系统设置->键盘->快捷键->应用快捷键->点击添加->应用程序选择Xcode，菜单标题输入FocusFile，键盘快捷键设置shift+command+L.

打开Xcode，点开ZZClang-foramt，就会发现显示在我们添加的菜单中了。
![快捷键](https://ws3.sinaimg.cn/large/006tNbRwgy1fxlh68qyd1j30ay072gmf.jpg)
