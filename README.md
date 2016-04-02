# NotBadScrollView 
#简单易用的图片轮播组件，正如名字所示，还不错哦

#优点：
1.不依赖任何其他第三方库

2.同时支持本地图片及网络图片

3.支持内存缓存和本地缓存

4.自定义分页控件的图片

5.性能好，轮播流畅

#使用方法
一.如何导入NotBadScrollView
######方式一：手动导入
将NotBadScrollView文件夹中的所有文件添加到项目中
######方式二：cocoapods导入
pod 'NotBadScrollView'

二.创建
######方式一：代码创建
1.导入主头文件 NotBadScrollView.h

2.使用initWithFrame:或者initWithFrame:imageArray:创建对象，设置各属性

3.将NotBadScrollView添加到要展示的视图上面
######方式二：xib\storyboard
1.添加一个view到xib\storyboard上

2.设置view的class为NotBadScrollView

3.拖线到.m文件中，设置各属性



#NotBadScrollView的常用属性方法

1.imageArray：轮播的图片数组，可传本地图片或网络图片路径

2.descriptionArray：图片描述的字符串数组，应与图片顺序对应

3.timeInterval：滚动间隔时间

4.startTimer\pauseTimer：开启\停止定时器，默认已开启

5.cleanImageCache：清除沙盒中的图片缓存


