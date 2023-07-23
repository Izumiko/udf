# Visual Studio或CLion使用CMake编译、调试Fluent UDF

项目源自[胶然今天打什么](https://zhuanlan.zhihu.com/p/492619039), 适用于Windows平台下调试UDF。



按如下目录结构摆放文件，并编辑CMakeLists.txt头部的设置信息。

```
/your_cas_folder:
├─ your_CAS.cas
│
└─/lib_name //自定义，编译完成后在fluent中输入这个库名就可以加载udf
    ├─/src
    │   ├─ your_udf.c //你的udf源文件
    │   ├─ CMakeLists.txt
    │   └─/support
    └─/win64  //编译完成的libudf.dll存放目录
```

