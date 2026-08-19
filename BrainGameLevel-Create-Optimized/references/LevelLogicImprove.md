# 完善关卡逻辑图

打开逻辑图文件阅读逻辑图内容并按照以下规则修改逻辑图。

修改前先阅读```references/LogicTableGrammar.md```逻辑图语法文件，再理解策划案中逻辑图的作用，再按以下规则进行修改



### 检查处理清单

0. 在操作分支的指令层开头添加”执行CheckGameOver"。
1. 操作对象交互完后需要隐藏。
2. 移除指令层不能识别的指令内容。
3. 出现"完成所有线索"，或者"完成所有条件“的特殊分支，则表明所有操作分支都需要调用该特殊分支，该特殊分支需要前置在所有操作分支前。
4. 出现"if 条件1~xx已完成“，“完成条件1~xx"的特殊分支，则表明被对应条件指令标记的操作分支需要调用该特殊分支，这个特殊分支需要前置，保证出现在调用前。
5. 如果在特殊分支的指令层出现“游戏胜利”，或“游戏成功”的指令，需要在该分支指令层开始添加“设置 winLevel = 操作分支数”，操作分支数取决于特殊分支调用的次数，然后再添加if指令，添加“if playerLevel == winLevel  最后需要在该特殊分支指令层末尾添加"end"
6. 操作分支在指令层开始添加“显示InputMask”，在末尾添加”隐藏InputMask"。
7. 如果连续出现用一物品类型不同动效名的两个动效指令，并且这两个动效还有T,F标记，这时要将这两个动效组合生特殊动效组指令。 例如

- 动效Panda_1_Pixel

  F                                                          -》    动效组Panda_1_Idle&Panda_1_Pixel&1

- 动效Panda_1_Idle

  T

  其中动效组最后一个数字从1开始，没出现一次递增+1。被F标注的动效只有一个播放，被T标注的动效有多个spine播放



#### 示例

**示例逻辑图**

- Level58

  - 游戏开始

    - 语音0

  - *Panda_1动效触发时

    - 每轮有1只错误反应的熊猫F，其余T    #在指令层无法识别为指令类型，需要移除

  - Fan_1

    - 点击

      - 提示101

      - Fan_1升级成Fan_2

      - 动效Panda_1_Paper

        F

      - 动效Panda_1_Idle

        T

      - 动效Boy_1_Astounded

      - 语音2

      - 音效wind

      - 等待1.5秒

      - 动效Boy_1_Idle

      - 条件2

  - Door_1

    - 左滑
      - 提示104
      - 解锁Door_2
      - 解锁Bucket_1

  - Panda_1

    - Bamboo_1

      - 提示100

      - 动效Panda_1_Kungfu

        F

      - 动效Panda_1_Idle

        T

      - 动效Boy_1_Astounded

      - 语音1

      - 音效wave

      - 等待3秒

      - 动效Boy_1_Idle

      - 条件1

  - 完成条件1-2

    - 解锁Finish_1
    - 语音9
    - 游戏胜利



处理后的效果:

Level58

- 游戏开始
  - 语音0
- 完成条件1-2                  #被条件1，2标记的分支依赖，放在分支的前面，并在操作分支后面调用该特殊分支
  - 设置 player = 2     # 添加设置 player = 条件数，条件数为2
  - if playerLevel == winLevel   # 添加if指令  if playerLevel == winLevel
  - 解锁Finish_1
  - 语音9
  - 等待3s               #需要等待语音9播放完后再游戏胜利
  - 游戏胜利
  - end
- Fan_1
  - 点击
    - 显示InputMask     #添加显示InputMask  因为分支中有等待指令
    - 执行CheckGameOver    #添加“执行CheckGameOver” 调用CheckGameOver特殊分支
    - 提示101
    - Fan_1升级成Fan_2            #因为升级过程中会隐藏低等级Fan_1,所以就不用再添加“隐藏Fan_1"
    - 动效组Panda_1_Idle&Panda_1_Paper&1      #连续两个同一物品类型的不同动效并且用F，T标记，需要合并成动效组
    - 动效Boy_1_Astounded
    - 语音2
    - 音效wind
    - 等待1.5秒
    - 动效Boy_1_Idle
    - 条件2
    - 执行完成条件1-2                      #调用特殊分支
    - 隐藏InputMask                     # 添加隐藏InputMask  因为分支中有等待指令
- Door_1
  - 左滑
    - 执行CheckGameOver
    - 提示104
    - 解锁Door_2       
    - 隐藏Door_1          #解锁高等级物品需要隐藏低等级物品
    - 解锁Bucket_1
- Panda_1
  - Bamboo_1
    - 显示InputMask                                   # 添加显示InputMask  因为分支中有等待指令
    - 执行CheckGameOver
    - 隐藏Bamboo_1                                      #操作对象交互后需要隐藏
    - 提示100
    - 动效组Panda_1_Idle&Panda_1_Kungfu&2      #连续两个同一物品类型的不同动效并且用F，T标记，需要合并成动效组 , 被T标记的动效名在被F标记的动效名后面。
    - 动效Boy_1_Astounded
    - 语音1
    - 音效wave
    - 等待3秒
    - 动效Boy_1_Idle
    - 条件1
    - 执行完成条件1-2             #调用特殊分支
    - 隐藏InputMask              # 添加隐藏InputMask  因为分支中有等待指令
