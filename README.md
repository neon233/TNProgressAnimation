# progressAnimation
####效果演示
![image](https://github.com/neon233/progressAnimation/blob/master/demo.gif)   
####日常说明
因为公司项目常常用到渐变进度条的展示，所以干脆写一个通用的。进度条的百分比可以直接赋值给maxRage（只能为0-1的小数）属性，文本展示的数值（只显示小数点后两位）则赋值给countValue属性，如颜色和线条宽度等则直接代码修改即可。  
今天（0310）被设计师吐槽了渐变的颜色值和他设计图不一致QAQ，只能含泪继续改。事实上iOS原生提供的渐变并不能满足他的要求。目前可以实现的渐变的两种机制，CAGradientLayer只能做线性渐变，而用CoreGraphics做的话,虽然渐变的效果会CAGradientLayer多一些，但是因为CoreGraphics是采用CPU绘制，性能方面会差一点，且我之前没有太多接触过CoreGraphics，代码的可读性并没有CAGradientLayer好。为了让设计师满意（QAQ），所以想到了一个非常完美且简单的解决办法——设计师给出他的渐变背景图，然后我这边利用mask属性，直接裁剪imageview，只要给出的渐变区域大于我的裁剪图层，就可以完美的保证设计师想要的任何效果。
####如果有问题或者更好的建议请Issue。
