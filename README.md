# iOS-SDK-Develope-AutoLink-EasyDebug

公司最近开发SDK，最开始使用原工程、SDK工程、SDK集成Demo验证三个工程分开的方式开发，每次都要在原工程开发实现效果后，将代码拖到SDK工程生成Framework，再将Framework导出到SDK集成Demo进行验证，做了很多不必要的机械性工作。本篇通过WorkSpace+SDK自动生成脚本相结合实现代码效果与SDK制作实现同步操作。

Demo地址[点这里](https://github.com/jingyiqiujing/iOS-SDK-Develope-AutoLink-EasyDebug)

# 1. 工作区（WorkSpace）结构

![SDK之WorkSpace工程结构](https://raw.githubusercontent.com/jingyiqiujing/GithubBlogResources/master/SDK%E4%B8%80%E9%94%AE%E5%88%9B%E5%BB%BA/SDK%E4%B9%8Bworkspace%E5%B7%A5%E7%A8%8B%E7%BB%93%E6%9E%84.png)

## 1.1 创建工作区

新建一个目录DevSDKWorkSpace,创建WorkSpace，选择刚才创建的目录。

![创建workspace](https://raw.githubusercontent.com/jingyiqiujing/GithubBlogResources/master/SDK%E4%B8%80%E9%94%AE%E5%88%9B%E5%BB%BA/%E5%88%9B%E5%BB%BAworkspace.png)

## 1.2 新建一个Project

首先创建原工程，选择刚刚创建的WorkSpace。

![新建Project](https://raw.githubusercontent.com/jingyiqiujing/GithubBlogResources/master/SDK%E4%B8%80%E9%94%AE%E5%88%9B%E5%BB%BA/%E6%96%B0%E5%BB%BAProject.png)


按照这样，创建好SDK集成Demo。

## 1.3 创建SDK工程之Framework工程

### 1.3.1 新建Project

选择CocoaTouchFramework，选择第一步创建的WorkSpace，这样就创建好了产生.framework和.a文件的SDK工程。

![SDK之SDK创建](https://raw.githubusercontent.com/jingyiqiujing/GithubBlogResources/master/SDK%E4%B8%80%E9%94%AE%E5%88%9B%E5%BB%BA/SDK%E5%88%9B%E5%BB%BASDK.png)

### 1.3.2 修改配置

创建好SDK中Framework工程后，修改其配置：

在Other Linker Flags 下添加一个-fembed-bitcode，增加Bitcode支持

![SDK之Framework配置](https://raw.githubusercontent.com/jingyiqiujing/GithubBlogResources/master/SDK%E4%B8%80%E9%94%AE%E5%88%9B%E5%BB%BA/SDK%E4%B9%8BFramework%E9%85%8D%E7%BD%AE.png)

### 1.3.3 新建一个Aggregate

![新建一个Aggregate](https://raw.githubusercontent.com/jingyiqiujing/GithubBlogResources/master/SDK%E4%B8%80%E9%94%AE%E5%88%9B%E5%BB%BA/SDK%E4%B9%8BAggregate.png)

选中刚刚创建的Aggregare,然后选中右侧的Build Phases,点击左边的+号，选择New Run Script Phases

![SDK之Aggregate嵌入脚本](https://raw.githubusercontent.com/jingyiqiujing/GithubBlogResources/master/SDK%E4%B8%80%E9%94%AE%E5%88%9B%E5%BB%BA/SDK%E4%B9%8BAggregate%E5%B5%8C%E5%85%A5%E8%84%9A%E6%9C%AC.png)

### 1.3.4 将下面的脚本复制进去

```bash
if [ "${ACTION}" = "build" ]
then

#要build的target名
target_Name=${PROJECT_NAME}
echo "target_Name=${target_Name}"


#build之后的文件夹路径
build_DIR=${SRCROOT}/build
echo "build_DIR=${build_DIR}"


#真机build生成的.framework文件路径
DEVICE_DIR_A=${build_DIR}/Release-iphoneos/${PROJECT_NAME}.framework
echo "DEVICE_DIR_A=${DEVICE_DIR_A}"
#模拟器build生成的.framework文件路径
SIMULATOR_DIR_A=${build_DIR}/Release-iphonesimulator/${PROJECT_NAME}.framework
echo "SIMULATOR_DIR_A=${SIMULATOR_DIR_A}"


#目标文件夹路径
INSTALL_DIR=${SRCROOT}/Products/${PROJECT_NAME}
echo "INSTALL_DIR=${INSTALL_DIR}"
#目标.framework路径
INSTALL_DIR_A=${SRCROOT}/Products/${PROJECT_NAME}/${PROJECT_NAME}.framework
echo "INSTALL_DIR_A=${INSTALL_DIR_A}"


#判断build文件夹是否存在，存在则删除
if [ -d "${build_DIR}" ]
then
rm -rf "${build_DIR}"
fi
#判断目标文件夹是否存在，存在则删除该文件夹
if [ -d "${INSTALL_DIR}" ]
then
rm -rf "${INSTALL_DIR}"
fi

#创建目标文件夹  -p会创建中间目录
mkdir -p "${INSTALL_DIR}"


#build之前clean一下
xcodebuild -target ${target_Name} clean
#模拟器build
xcodebuild -target ${target_Name} -configuration Release -sdk iphonesimulator
#真机build
xcodebuild -target ${target_Name} -configuration Release -sdk iphoneos


cp -R "${DEVICE_DIR_A}" "${INSTALL_DIR_A}"

#合成模拟器和真机.framework包
lipo -create "${DEVICE_DIR_A}/${PROJECT_NAME}" "${SIMULATOR_DIR_A}/${PROJECT_NAME}" -output "${INSTALL_DIR_A}/${PROJECT_NAME}"

#打开目标文件夹
open "${INSTALL_DIR}"

fi
```

![SDK之脚本嵌入](https://raw.githubusercontent.com/jingyiqiujing/GithubBlogResources/master/SDK%E4%B8%80%E9%94%AE%E5%88%9B%E5%BB%BA/SDK%E4%B9%8BAggregate%E8%84%9A%E6%9C%AC%E5%B5%8C%E5%85%A5.png)

### 1.3.5 直接编译

Command+B直接编译，产生.framework。

![SDK之Aggregate编译](https://raw.githubusercontent.com/jingyiqiujing/GithubBlogResources/master/SDK%E4%B8%80%E9%94%AE%E5%88%9B%E5%BB%BA/SDK%E4%B9%8BAggregate%E7%BC%96%E8%AF%91.png)

### 1.3.6 添加新文件

添加新文件，将需要暴露的文件进行配置。

![SDK之Framework暴露文件配置](https://raw.githubusercontent.com/jingyiqiujing/GithubBlogResources/master/SDK%E4%B8%80%E9%94%AE%E5%88%9B%E5%BB%BA/SDK%E4%B9%8BFramework%E6%9A%B4%E9%9C%B2%E6%96%87%E4%BB%B6%E9%85%8D%E7%BD%AE.png)

## 1.4 创建SDK工程之.a工程

### 1.4.1 创建.a工程及配置
基本步骤与FrameWork工程一致，第一步要选择CocoaTouchStaticLibrary。

然后，直接跳到第四步，将如下脚本复制进去。

```bash
if [ "${ACTION}" = "build" ]
then

#要build的target名
target_Name=${PROJECT_NAME}
echo "target_Name=${target_Name}"

#build之后的文件夹路径
build_DIR=${SRCROOT}/build
echo "build_DIR=${build_DIR}"

#真机build生成的头文件的文件夹路径
DEVICE_DIR_INCLUDE=${build_DIR}/Release-iphoneos/include/${PROJECT_NAME}
echo "DEVICE_DIR_INCLUDE=${DEVICE_DIR_INCLUDE}"

#真机build生成的.a文件路径
DEVICE_DIR_A=${build_DIR}/Release-iphoneos/lib${PROJECT_NAME}.a
echo "DEVICE_DIR_A=${DEVICE_DIR_A}"

#模拟器build生成的.a文件路径
SIMULATOR_DIR_A=${build_DIR}/Release-iphonesimulator/lib${PROJECT_NAME}.a
echo "SIMULATOR_DIR_A=${SIMULATOR_DIR_A}"

#目标文件夹路径
INSTALL_DIR=${SRCROOT}/Products/${PROJECT_NAME}
echo "INSTALL_DIR=${INSTALL_DIR}"

#目标头文件文件夹路径
INSTALL_DIR_Headers=${SRCROOT}/Products/${PROJECT_NAME}/Headers
echo "INSTALL_DIR_Headers=${INSTALL_DIR_Headers}"

#目标.a路径
INSTALL_DIR_A=${SRCROOT}/Products/${PROJECT_NAME}/lib${PROJECT_NAME}.a
echo "INSTALL_DIR_A=${INSTALL_DIR_A}"

#判断build文件夹是否存在，存在则删除
if [ -d "${build_DIR}" ]
then
rm -rf "${build_DIR}"
fi

#判断目标文件夹是否存在，存在则删除该文件夹
if [ -d "${INSTALL_DIR}" ]
then
rm -rf "${INSTALL_DIR}"
fi
#创建目标文件夹
mkdir -p "${INSTALL_DIR}"

#build之前clean一下
xcodebuild -target ${target_Name} clean

#模拟器build
xcodebuild -target ${target_Name} -configuration Release -sdk iphonesimulator

#真机build
xcodebuild -target ${target_Name} -configuration Release -sdk iphoneos

#复制头文件到目标文件夹
cp -R "${DEVICE_DIR_INCLUDE}" "${INSTALL_DIR_Headers}"

#合成模拟器和真机.a包
lipo -create "${DEVICE_DIR_A}" "${SIMULATOR_DIR_A}" -output "${INSTALL_DIR_A}"

#打开目标文件夹
open "${INSTALL_DIR}"

fi
```

### 1.4.2 编译

Command+B直接编译，产生.a及暴露的头文件（Headers文件夹中）。

![SDK之Aggregate编译.a](https://raw.githubusercontent.com/jingyiqiujing/GithubBlogResources/master/SDK%E4%B8%80%E9%94%AE%E5%88%9B%E5%BB%BA/SDK%E4%B9%8BAggregate%E7%BC%96%E8%AF%91.a.png)

### 1.4.3 添加新文件

添加新文件，将需要暴露的文件进行配置。

![SDK之静态.a生成所有要暴露的h都添加在这里](https://raw.githubusercontent.com/jingyiqiujing/GithubBlogResources/master/SDK%E4%B8%80%E9%94%AE%E5%88%9B%E5%BB%BA/SDK%E4%B9%8B%E9%9D%99%E6%80%81.a%E7%94%9F%E6%88%90%E6%89%80%E6%9C%89%E8%A6%81%E6%9A%B4%E9%9C%B2%E7%9A%84h%E9%83%BD%E6%B7%BB%E5%8A%A0%E5%9C%A8%E8%BF%99%E9%87%8C.png)


## 1.5 目录结构

目录的最终结构如图所示：

> ADreamClusive为原工程
>
> ADreamClusiveSDK和ADreamClusiveStasticSDK为(分别产生Framework和.a)SDK工程
> 
> ADSDKDemo为SDK集成Demo。

![SDK之目录](https://raw.githubusercontent.com/jingyiqiujing/GithubBlogResources/master/SDK%E4%B8%80%E9%94%AE%E5%88%9B%E5%BB%BA/SDK%E4%B9%8B%E7%9B%AE%E5%BD%95.png)


# 2. 将1.3和1.4产生的SDK与SDK集成Demo进行关联

将1.3产生的.framework拖到ADSDKDemo工程中

使用SDK之.framework运行ADSDKDemo。

![SDK之Framework调用](https://raw.githubusercontent.com/jingyiqiujing/GithubBlogResources/master/SDK%E4%B8%80%E9%94%AE%E5%88%9B%E5%BB%BA/SDK%E4%B9%8BFramework%E8%B0%83%E7%94%A8.png)

修改SDK中HomeViewController内容，再次编译运行ADSDKDemo查看效果😊！！！

集成.a的方式与.framework类型，不再赘述。

# 3. 创建使用Bundle资源包

我们的项目中难免会用到图片资源和xib，storyboatd资源，我们可以将这些资源全部归类到bundle文件中，便于管理。

## 3.1 创建Bundle

![SDK之Bundle创建](https://raw.githubusercontent.com/jingyiqiujing/GithubBlogResources/master/SDK%E4%B8%80%E9%94%AE%E5%88%9B%E5%BB%BA/SDK%E4%B9%8BBundle%E5%88%9B%E5%BB%BA.png)

## 3.2 配置

1. 删除安装目录Bundle文件不需要安装
2. 设置COMBINE_HIDPI_IMAGES参数为NO,不然图片会被打包成.tiff后缀
3. 设置bundle包与framework的关联

![SDK之bundle配置](https://raw.githubusercontent.com/jingyiqiujing/GithubBlogResources/master/SDK%E4%B8%80%E9%94%AE%E5%88%9B%E5%BB%BA/SDK%E4%B9%8Bbundle%E9%85%8D%E7%BD%AE.png)

> 这样bundle的修改就能实时反映出来

## 3.3 生成SDK及使用

编译运行产生bundle文件，找到bundle文件，并将bundle包拖到测试demo的目录下面（选择Create folder reference）。

![SDK之Bundle生成使用](https://raw.githubusercontent.com/jingyiqiujing/GithubBlogResources/master/SDK%E4%B8%80%E9%94%AE%E5%88%9B%E5%BB%BA/SDK%E4%B9%8BBundle%E7%94%9F%E6%88%90%E4%BD%BF%E7%94%A8.png)

## 3.4 使用bundle中的资源

```objc
NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"ADreamClusiveBundle" ofType:@"bundle"];
NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];

// VC的nib资源
UIViewController *vc = [[UIViewController alloc] initWithNibName:@"vc_name" bundle:resourceBundle];

// 图片资源
UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(120, 50, 100, 50)];
imgView2.image = [UIImage imageNamed:@"buynew" inBundle:resourceBundle compatibleWithTraitCollection:nil];
[self.view addSubview:imgView2];

UIImageView *imgView3 = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
imgView3.image = [UIImage imageNamed:@"demo"];
[self.view addSubview:imgView3];
```

## 3.5 此外还可以直接创建一个bundle

省去很多配置，也可以达到上述效果

![SDK之bundle直接方式](https://raw.githubusercontent.com/jingyiqiujing/GithubBlogResources/master/SDK%E4%B8%80%E9%94%AE%E5%88%9B%E5%BB%BA/SDK%E4%B9%8Bbundle%E7%9B%B4%E6%8E%A5%E6%96%B9%E5%BC%8F.png)



