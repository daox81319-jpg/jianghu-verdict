<title>《江湖裁决》3D 资产生产包</title>

# 《江湖裁决》3D 资产生产包

> 本文档合并资产规格清单与 14 张概念参考图，供 Tripo3D + Blender 生产流程使用。

## 总览概念图

![图 01：游戏主 KV。江湖令主坐于高堂，各门派代表跪于下方，整体为暗色水墨、金色权力符号与压迫式纵深。](https://feishu.cn/file/NniWbwcp4oeVpmxYTcccr5dTnBc)

![图 08：游戏 UI 风格样张。裁决界面、NPC 对话框、声望系统、派系关系条与判印按钮的统一 UI 气质。](https://feishu.cn/file/ACPhbF9qeodbilxpCTyctOahnmd)

---

# 《江湖裁决》首批 3D 视觉资产生产规格清单

> 目标：本文件面向 Tripo3D + Blender 制作流程。概念参考图已生成，3D 提示词与 Blender MCP 建模指令可直接交给 3D 美术或自动化建模流程执行。

## 0. 统一美术方向

- **关键词**：高写实水墨、暗金、黑漆木、旧铜、湿冷石面、烟雾、压迫感、权力感、成人向武侠政治博弈。
- **禁止项**：可爱风、Q版、卡通、过度奇幻发光、现代科技感、亮糖果色、战斗技能特效喧宾夺主。
- **PBR 材质基准**：black lacquered wood, aged bronze, tarnished dark gold, worn leather, rough stone, aged parchment, dark silk, wet stone reflections.
- **建模姿态**：角色默认 A-pose / neutral standing pose，另做 seated/ kneeling pose 用于场景摆放；服装保持层次但避免不可拓扑化的碎片。
- **推荐精度**：主角与核心 NPC 60k-90k triangles；普通 NPC 35k-60k triangles；背景人物 8k-18k triangles；大型场景模块按模块 10k-80k triangles；道具 1k-15k triangles。

## 1. 已生成概念参考图

| 编号 | 内容 | 图片文件 | 中文说明 |
|-|-|-|-|
| 01 | 游戏主 KV | [generated_image_231509.jpg](https://generated_image_231509.jpg) | 江湖令主坐于高堂，各门派代表跪于下方，整体为暗色水墨、金色权力符号与压迫式纵深。 |
| 02 | 裁决大堂正面场景 | [generated_image_231516.jpg](https://generated_image_231516.jpg) | 古代公堂与江湖门派建筑融合，正面对称构图，适合作为主界面/核心场景建模参考。 |
| 03 | 刀客门代表 | [generated_image_231520.jpg](https://generated_image_231520.jpg) | 厚重皮甲、断刃徽记、背负大刀，强调粗粝、直接、压迫感。 |
| 04 | 毒门代表 | [generated_image_231525.jpg](https://generated_image_231525.jpg) | 暗绿黑袍、蛇纹、毒瓶与针器，强调危险、优雅、操控感。 |
| 05 | 佛门代表 | [generated_image_231530.jpg](https://generated_image_231530.jpg) | 暗赭袈裟、佛珠、铁杖、金色经文，强调庄严与克制的武力。 |
| 06 | 皇家鹰卫代表 | [generated_image_231534.jpg](https://generated_image_231534.jpg) | 黑鳞甲、鹰徽、官帽与佩剑，强调帝国权力与监视感。 |
| 07 | 隐世剑宗代表 | [generated_image_231538.jpg](https://generated_image_231538.jpg) | 素袍、斗笠、长剑、山雾，强调冷峻、孤高、克制。 |
| 08 | 游戏 UI 样张 | [generated_image_231543.jpg](https://generated_image_231543.jpg) | 裁决界面、NPC 对话框、声望系统、派系关系条与判印按钮的统一 UI 气质。 |
| 09 | 江湖令主主角 | [generated_image_231608.jpg](https://generated_image_231608.jpg) | 黑金礼袍、令印、半遮面权力感，适合主角 3D 生产参考。 |
| 10 | 丐帮代表 | [generated_image_231614.jpg](https://generated_image_231614.jpg) | 补丁灰袍、竹杖、消息筒与暗藏令牌，强调市井情报网络。 |
| 11 | 商会代表 | [generated_image_231619.jpg](https://generated_image_231619.jpg) | 暗金锦袍、算盘、契约卷轴与戒印，强调利益博弈。 |
| 12 | 异火教代表 | [generated_image_231623.jpg](https://generated_image_231623.jpg) | 黑红祭袍、火焰纹、半面具与仪式短刃，强调邪性但不魔幻过载。 |
| 13 | 外景与门派场景参考 | [generated_image_231646.jpg](https://generated_image_231646.jpg) | 大堂外景、刀客门、毒门、佛门、鹰卫、剑宗等场景气质缩略参考。 |
| 14 | 道具概念参考 | [generated_image_231648.jpg](https://generated_image_231648.jpg) | 令牌、判印、卷轴、证物箱、门派徽牌、武器与界面 3D 元件参考。 |

---

## 2. Tripo3D 英文建模提示词清单

### 2.1 角色模型

![图 09：江湖令主主角。黑金礼袍、令印、半遮面权力感，适合主角 3D 生产参考。](https://feishu.cn/file/NhAob30dmoGdYRxR4I0ce1EbnWf)

![图 03：刀客门代表。厚重皮甲、断刃徽记、背负大刀，强调粗粝、直接、压迫感。](https://feishu.cn/file/BbjbbE4WtoQqmHxcTN7cUHfXnVe)

![图 04：毒门代表。暗绿黑袍、蛇纹、毒瓶与针器，强调危险、优雅、操控感。](https://feishu.cn/file/Ev4hbHAnIosykDxWQCrc9TDWnmc)

![图 05：佛门代表。暗赭袈裟、佛珠、铁杖、金色经文，强调庄严与克制的武力。](https://feishu.cn/file/QOcEbpR3xog5RYx80cfcOB9onQb)

![图 06：皇家鹰卫代表。黑鳞甲、鹰徽、官帽与佩剑，强调帝国权力与监视感。](https://feishu.cn/file/ExrHbO0ewoKHLgxfeVmccQsWn0e)

![图 07：隐世剑宗代表。素袍、斗笠、长剑、山雾，强调冷峻、孤高、克制。](https://feishu.cn/file/YHjjbKVjZolqbWxs0SScotsvnke)

![图 10：丐帮代表。补丁灰袍、竹杖、消息筒与暗藏令牌，强调市井情报网络。](https://feishu.cn/file/LATcbsflRo0wXBxG7nqcb4vVnug)

![图 11：商会代表。暗金锦袍、算盘、契约卷轴与戒印，强调利益博弈。](https://feishu.cn/file/RxaHb2Ospoqbp2xNAEqcA5j8nVf)

![图 12：异火教代表。黑红祭袍、火焰纹、半面具与仪式短刃，强调邪性但不魔幻过载。](https://feishu.cn/file/Z7Fjb1iRloMh1wxTPxbcCjX5nBg)

| 资产名 | 用途 | Tripo3D Prompt（English） | Blender 关键参数 | 预估面数/精度 |
|-|-|-|-|-|
| Jianghu Lord / 江湖令主 | 玩家主角、主界面王座角色、裁决动画核心 | Full-body 3D game character, neutral A-pose, realistic Chinese wuxia tribunal lord, black layered ceremonial robe with tarnished dark gold cloud embroidery, high collar, subtle armor under robe, jade and bronze command seal in one hand, stern shadowed face, long sleeves, authoritative silhouette, grounded historical fantasy, PBR materials, production-ready topology, no cartoon, no chibi, no modern items. | 身高 1.86m；头身比 7.5；黑金长袍 3 层布料；单独建模：令印、腰牌、袖口金纹；LOD0/1/2；骨骼兼容 Humanoid。 | LOD0 80k-90k tris，高精度 |
| Blade Gate Envoy / 刀客门代表 | 申诉 NPC、强硬派系代表 | Full-body 3D game character, neutral A-pose, realistic weathered wuxia saber master, middle-aged male, heavy dark leather lamellar armor, black cloak with tarnished gold trim, oversized curved dao saber on back, facial scars, broken blade sect insignia, rain-worn boots, stern expression, PBR leather metal cloth, production-ready topology, no cartoon. | 身高 1.82m；大刀长度 1.35m；皮甲分片可拆；披风布料模拟；刀鞘独立骨点。 | 65k-80k tris，高精度 |
| Poison Sect Envoy / 毒门代表 | 阴谋型 NPC、毒门争辩与威胁感 | Full-body 3D game character, neutral A-pose, realistic elegant Poison Sect envoy, dark green and black layered robes, tarnished gold serpent embroidery, jade poison vials on belt, needle weapon, pale face, calm manipulative expression, subtle toxic mist accessories, grounded wuxia style, PBR silk jade metal glass, production-ready topology, no cartoon. | 身高 1.72m；毒瓶 6-8 个可拆；针器独立；蛇纹用法线/贴图；衣摆分层。 | 60k-75k tris，高精度 |
| Buddhist Monastery Envoy / 佛门代表 | 道义型 NPC、调停/威慑角色 | Full-body 3D game character, neutral A-pose, realistic warrior monk envoy, dark ochre kasaya robe over black underlayer, subtle gold sutra embroidery, large wooden prayer beads, heavy iron staff, shaved head, old battle scars, solemn compassionate but intimidating face, PBR cloth wood metal, production-ready topology, no cartoon. | 身高 1.88m；铁杖 1.7m；佛珠 18-27 颗独立；袈裟用布料权重；经文贴图可替换。 | 60k-75k tris，高精度 |
| Royal Eagle Guard Envoy / 皇家鹰卫 | 朝廷势力 NPC、压迫与监视感 | Full-body 3D game character, neutral A-pose, realistic imperial eagle guard investigator, black scale armor, dark gold eagle crest, official hat, red-black cloak, metal gauntlets, waist command tablet, straight sword, cold disciplined expression, authoritarian Chinese wuxia political style, PBR metal cloth leather, production-ready topology, no cartoon. | 身高 1.80m；鳞甲使用 tileable normal；鹰徽单独浮雕；佩剑 1.05m；披风低风阻。 | 70k-85k tris，高精度 |
| Hidden Sword Sect Envoy / 隐世剑宗 | 冷峻派系 NPC、孤高剑客 | Full-body 3D game character, neutral A-pose, realistic reclusive swordsman, long pale travel-stained robe, black inner garment, restrained dark gold thread, slim ancient jian sword, bamboo rain hat, calm noble face partly shadowed, flowing sleeves, grounded wuxia, PBR cloth bamboo metal, production-ready topology, no cartoon. | 身高 1.78m；斗笠半径 0.42m；剑 1.05m；袍摆轻薄；发带/袖带可动态。 | 55k-70k tris，高精度 |
| Beggar Alliance Envoy / 丐帮代表 | 情报型 NPC、市井势力 | Full-body 3D game character, neutral A-pose, realistic aged Beggar Alliance intelligence broker, patched dark gray robe, rope belts, bamboo staff, hidden tarnished gold token, many pouches and message tubes, sharp streetwise eyes, cracked gourd insignia, PBR rough cloth bamboo leather bronze, production-ready topology, no cartoon. | 身高 1.70m；补丁贴图 atlas；竹杖 1.55m；腰包 5 个；消息筒可交互。 | 45k-60k tris，中高精度 |
| Merchant Guild Envoy / 商会代表 | 利益博弈 NPC、交易与证词 | Full-body 3D game character, neutral A-pose, realistic wealthy jianghu merchant negotiator, dark silk robe with muted gold brocade, abacus beads, contract scroll case, signet ring, concealed dagger, guarded smile, coin and scale faction emblem, PBR silk jade bronze parchment, production-ready topology, no cartoon. | 身高 1.73m；算盘珠可独立；卷轴筒挂腰；戒印高光；袖口宽大。 | 50k-65k tris，中高精度 |
| Heretical Flame Cult Envoy / 异火教代表 | 高风险邪派 NPC、激进博弈方 | Full-body 3D game character, neutral A-pose, realistic heretical flame cult envoy, black crimson ceremonial robe, tarnished dark gold fire sigils, bone ornaments, ritual curved dagger, half mask, intense eyes, ash-stained fabric, grounded dark wuxia, no glowing fantasy overload, PBR cloth bone metal, production-ready topology, no cartoon. | 身高 1.76m；半面具可拆；火纹用暗金刺绣；骨饰 8-12 件；短刃 0.45m。 | 55k-70k tris，高精度 |
| Background Kneeling Petitioner A / 跪诉百姓 | 大堂下方背景人物 | Low to mid-poly realistic Chinese wuxia civilian petitioner, kneeling pose, worn dark cloth robe, simple hair bun, anxious face, aged fabric, no weapons, PBR cloth, optimized game background NPC, no cartoon. | 1.65-1.75m；跪姿骨骼；服装贴图复用；2-3 个头部变体。 | 8k-15k tris，背景精度 |
| Background Scribe / 书记官 | 大堂记录员、信息界面叙事 | Low to mid-poly realistic tribunal scribe, seated or standing, dark official robe, writing brush, bamboo slips and scrolls, modest dark gold trim, PBR cloth wood parchment, optimized background NPC. | 坐姿/站姿两套；毛笔与案台可拆；面部低精。 | 12k-18k tris，背景精度 |
| Background Guard / 堂前护卫 | 维持秩序的背景角色 | Low to mid-poly realistic wuxia tribunal guard, black leather armor, simple polearm, dark gold badge, masked or shadowed face, grounded style, optimized background NPC, no cartoon. | 1.80m；长柄武器 1.9m；可换头盔/面罩；队列摆放。 | 12k-20k tris，背景精度 |
| Background Sect Disciple / 门派弟子通用 | 各门派随从变体 | Low-poly modular wuxia sect disciple, neutral A-pose, interchangeable robe colors dark gray green ochre red, simple belt, small faction badge, optimized crowd character, PBR cloth, no cartoon. | 服装颜色材质实例化；徽章可替换 8 种；男女体型各 1。 | 8k-16k tris，背景精度 |
| Background Messenger / 传令人 | 递送案件/令牌动画 | Low to mid-poly realistic jianghu messenger, short dark robe, leather satchel, message tubes, wet boots, fast agile silhouette, PBR cloth leather bamboo, optimized NPC. | 身高 1.68m；信筒 3 个；跑步动画友好；面部低精。 | 10k-18k tris，背景精度 |

### 2.2 场景模型

![图 02：裁决大堂正面场景。古代公堂与江湖门派建筑融合，正面对称构图，适合作为主界面/核心场景建模参考。](https://feishu.cn/file/Z7ZubXyTloHUlLx50dGcoFlJnoe)

![图 13：外景与门派场景参考。大堂外景、刀客门、毒门、佛门、鹰卫、剑宗等场景气质缩略参考。](https://feishu.cn/file/UyMHbzbEmosUErxnRgFce9BJnlb)

| 资产名 | 用途 | Tripo3D Prompt（English） | Blender 关键参数 | 预估面数/精度 |
|-|-|-|-|-|
| Judgment Hall Interior / 裁决大堂 | 核心游戏场景、主交互空间 | Large modular 3D environment, realistic dark wuxia tribunal hall interior, ancient Chinese court mixed with martial sect architecture, high stone dais, carved judgment throne, black lacquered beams, dark gold plaque, faction banners, bronze incense braziers, weapon racks, evidence tables, scroll shelves, wet black stone floor, oppressive cinematic scale, PBR materials, modular game-ready assets, no cartoon. | 尺寸约 28m x 18m x 14m；分模块：地面、台阶、梁柱、王座、案台、帷幕、香炉、证物区；中轴对称；灯光暖金+冷青。 | 场景总 250k-450k tris，模块化高精 |
| Hall Exterior / 裁决堂外景 | 章节入口、转场镜头 | Realistic 3D exterior of a dark wuxia judgment hall in rain, stone stairs, black timber gate, dark gold tribunal plaque, hanging lanterns, misty mountains, wet stone courtyard, severe political atmosphere, PBR stone wood bronze cloth, game-ready modular environment, no cartoon. | 尺寸约 40m x 30m；可拆：大门、台阶、围墙、灯笼、牌匾、雨棚；制作雨夜材质。 | 180k-320k tris，高精环境 |
| Blade Gate Fortress / 刀客门断崖堡 | 门派剧情场景 | Realistic 3D wuxia cliff fortress for Blade Gate, rough black stone walls, weapon racks full of sabers, torn banners, training yard, rain and wind atmosphere, tarnished gold broken blade emblems, PBR stone metal wood leather, modular environment, no cartoon. | 山崖背景可低模；训练架/刀架独立；旗帜可动态；主门 8m 宽。 | 160k-280k tris，中高精 |
| Poison Sect Swamp Pavilion / 毒门沼亭 | 门派剧情场景 | Realistic 3D poison sect swamp pavilion, dark green mist, wooden walkways, apothecary shelves, hanging herbs, jade vials, serpent carved posts, black water, tarnished gold details, grounded dark wuxia, PBR wood glass cloth water, game-ready modular scene, no cartoon. | 水面 shader；药架/瓶罐 modular；雾效单独 VFX；蛇柱 4 根。 | 150k-260k tris，中高精 |
| Buddhist Monastery Court / 佛门山寺 | 门派剧情场景 | Realistic 3D mountain monastery courtyard, dark stone tiles, old bronze bell, incense burners, prayer flag shadows, solemn warrior monk training space, restrained dark gold sutra plaques, misty cliffs, PBR stone wood bronze cloth, game-ready modular environment, no cartoon. | 钟楼、香炉、经幡、石阶分组；适合晨雾/阴天两套灯光。 | 160k-280k tris，中高精 |
| Royal Eagle Bureau / 鹰卫府署 | 朝廷势力场景 | Realistic 3D imperial eagle guard bureau interior and gate, black official architecture, eagle crest plaques, document archives, interrogation table, red-black banners, dark gold trims, severe surveillance atmosphere, PBR lacquer wood bronze parchment, modular game environment, no cartoon. | 档案柜模块复用；审讯桌交互；鹰徽浮雕；门禁栅栏。 | 180k-300k tris，高精 |
| Hidden Sword Valley / 隐世剑谷 | 剑宗场景 | Realistic 3D hidden sword sect mountain valley, snowy bamboo forest, narrow stone path, old sword steles, pale cloth banners, mist, minimal dark gold sword emblems, grounded wuxia serenity with hidden danger, PBR stone bamboo snow cloth metal, modular environment, no cartoon. | 远景山体低模；竹林实例化；剑碑 6-10 种；雪覆盖材质。 | 140k-240k tris，中高精 |
| Beggar Alliance Alley / 丐帮暗巷 | 情报场景 | Realistic 3D jianghu back alley hideout, rain-soaked stone alley, patched awnings, gourd signs, hidden message wall, bamboo baskets, old tea stall, muted dark gold token marks, PBR stone cloth bamboo wood, modular game-ready scene, no cartoon. | 巷道宽 4m；可复用摊位/竹筐/布棚；湿地贴花。 | 120k-220k tris，中精 |
| Merchant Guild Hall / 商会密议厅 | 交易与证据场景 | Realistic 3D wealthy merchant guild negotiation hall, dark polished wood, gold brocade screens, abacus tables, contract scroll racks, locked chests, muted dark gold coin and scale emblems, grounded wuxia commerce atmosphere, PBR silk wood bronze parchment, modular environment, no cartoon. | 桌椅/屏风/箱柜 modular；金纹控制粗糙度；可做昼夜两套。 | 160k-260k tris，中高精 |
| Heretical Flame Shrine / 异火教密坛 | 高风险门派场景 | Realistic 3D secret heretical flame cult shrine, black stone chamber, crimson cloth, dark gold fire sigils, bone ornaments, ash floor, ritual altar, weak candlelight not fantasy flames, grounded dark wuxia, PBR stone cloth bone bronze, modular scene, no cartoon. | 祭坛中心 4m；蜡烛/骨饰实例化；火纹贴图暗金不强发光。 | 150k-260k tris，中高精 |

### 2.3 道具与 UI 3D 元素

![图 14：道具概念参考。令牌、判印、卷轴、证物箱、门派徽牌、武器与界面 3D 元件参考。](https://feishu.cn/file/VrYrbg9CPo9C4Jx1ncYcB2hin0c)

| 资产名 | 用途 | Tripo3D Prompt（English） | Blender 关键参数 | 预估面数/精度 |
|-|-|-|-|-|
| Jianghu Command Token / 江湖令牌 | 主角权力象征、UI 图标、剧情道具 | Realistic 3D ancient Chinese jianghu command token, black jade core with tarnished dark gold frame, engraved tribunal characters and cloud patterns, worn edges, heavy authoritative object, PBR jade bronze, game-ready prop, no cartoon. | 12cm x 7cm x 1cm；正反两面；法线雕刻文字；可挂腰。 | 6k-12k tris，高精道具 |
| Judgment Seal / 裁决印章 | 裁决按钮、判词盖章动画 | Realistic 3D bronze judgment seal stamp, square heavy base, dark gold tarnished metal, carved dragon and cloud motifs, red wax residue, ancient Chinese tribunal prop, PBR bronze wax, game-ready. | 9cm x 9cm x 14cm；底面反刻纹；盖章动画 pivot 在底面。 | 8k-15k tris，高精道具 |
| Verdict Scroll Set / 文书卷轴组 | 案件信息、对话证据 | Realistic 3D set of ancient Chinese case scrolls, aged parchment, bamboo rods, black silk ties, red wax seals, handwritten ink patterns, PBR parchment bamboo wax, game-ready props. | 3-5 种长度；卷起/展开两态；文字用贴图层。 | 2k-8k tris/件，中精 |
| Judge Desk / 裁决案台 | 主场景交互台 | Realistic 3D carved black lacquer Chinese tribunal judge desk, dark gold edge trim, scratches, document grooves, incense ash, PBR lacquer wood bronze, game-ready furniture. | 2.8m x 0.9m x 0.9m；抽屉/案面分离；边角磨损贴图。 | 20k-35k tris，高精家具 |
| Evidence Box / 证物箱 | 案件证据展示 | Realistic 3D ancient evidence box, black wood, bronze lock, red paper seal, worn corners, dark wuxia tribunal prop, PBR wood bronze paper. | 0.6m x 0.35m x 0.3m；盖子可开合；封条独立。 | 5k-10k tris，中精 |
| Faction Crest Plaques / 门派徽牌套组 | 声望系统、关系 UI、场景标识 | Realistic 3D set of eight wuxia faction crest plaques: broken blade, serpent vial, lotus staff, imperial eagle, hidden sword, cracked gourd, coin scale, black flame; tarnished dark gold on black lacquer, PBR metal wood, game-ready icons. | 每枚直径 10-18cm；统一底座；8 个徽记可替换；UI/场景双用。 | 2k-6k tris/枚，中精 |
| Weapon Prop Set / 门派武器组 | 角色配件与证物 | Realistic 3D wuxia weapon prop set: curved dao saber, thin poison needle, iron monk staff, imperial straight sword, slim ancient jian, bamboo beggar staff, merchant concealed dagger, ritual curved dagger, PBR metal wood leather, game-ready, no cartoon. | 每件独立 mesh；统一 texel density；武器 pivot 在握持点。 | 3k-15k tris/件，中高精 |
| Reputation Meter 3D UI / 声望标尺 | 声望系统 UI 3D 元素 | Realistic 3D dark gold reputation meter UI object, black lacquer horizontal scale, bronze faction markers, red wax indicator, carved cloud patterns, game interface prop, PBR material, no cartoon. | 长 1.2m UI 模型；marker 可滑动；分 5 档刻度。 | 8k-18k tris，高精 UI 道具 |
| Dialogue Frame 3D UI / NPC 对话框边框 | 对话 UI 样式资产 | Realistic 3D UI frame for wuxia dialogue box, black lacquer carved border, tarnished gold corners, parchment inner panel, subtle ink wash texture, game-ready interface asset, no cartoon. | 16:9/4:1 两套比例；角饰九宫格切片；贴图可无损缩放。 | 6k-12k tris，中高精 UI |
| Verdict Button 3D UI / 裁决按钮 | 关键交互按钮 | Realistic 3D circular verdict button, dark bronze rim, red wax center, gold seal glyph relief, pressed and unpressed states, authoritative wuxia UI prop, PBR bronze wax, game-ready. | 直径 18cm；按下位移 1.5cm；hover 金边 emissive 极弱。 | 4k-8k tris，中精 UI |

---

## 3. Blender MCP 自动化建模指令清单

以下是面向 Blender MCP/自动化建模 Agent 的执行清单。建议按 Collection 分层建模，先完成 blockout，再细化高模与 PBR 材质。

### 3.1 全局工程初始化

```Plaintext
CREATE_PROJECT name="JianghuVerdict_AssetPack"
SET_UNITS unit_system="METRIC" length_unit="METERS"
SET_RENDER_ENGINE engine="CYCLES" samples=128 color_management="Filmic" look="Medium High Contrast"
CREATE_COLLECTION "00_References"
CREATE_COLLECTION "01_Characters_Hero"
CREATE_COLLECTION "02_Characters_NPC"
CREATE_COLLECTION "03_Background_Crowd"
CREATE_COLLECTION "04_Environments"
CREATE_COLLECTION "05_Props"
CREATE_COLLECTION "06_UI_3D"
CREATE_COLLECTION "07_Lights_Cameras"
CREATE_MATERIAL "Black_Lacquer_Wood" base_color="#070606" roughness=0.32 metallic=0.0 clearcoat=0.55
CREATE_MATERIAL "Tarnished_Dark_Gold" base_color="#8A6426" roughness=0.48 metallic=1.0
CREATE_MATERIAL "Aged_Bronze" base_color="#5F472A" roughness=0.58 metallic=1.0
CREATE_MATERIAL "Wet_Black_Stone" base_color="#0B0D0F" roughness=0.18 metallic=0.0
CREATE_MATERIAL "Aged_Parchment" base_color="#B89C6A" roughness=0.72 metallic=0.0
CREATE_MATERIAL "Dark_Silk" base_color="#111014" roughness=0.42 sheen=0.35
CREATE_MATERIAL "Crimson_Wax" base_color="#641616" roughness=0.38 metallic=0.0
CREATE_AREA_LIGHT name="High_Hall_Cold_Key" location=(0,-8,10) rotation=(60,0,0) power=600 size=7 color="#AFC4D6"
CREATE_AREA_LIGHT name="Dais_Dark_Gold_Rim" location=(0,3,5) rotation=(55,0,180) power=350 size=4 color="#B98A3B"
CREATE_CAMERA name="Main_KV_Camera" focal_length=35 location=(0,-16,5.2) rotation=(72,0,0)
```

### 3.2 角色建模通用指令

```Plaintext
FOR_EACH character IN [Jianghu_Lord, Blade_Gate_Envoy, Poison_Sect_Envoy, Buddhist_Monk_Envoy, Royal_Eagle_Guard_Envoy, Hidden_Sword_Envoy, Beggar_Alliance_Envoy, Merchant_Guild_Envoy, Heretical_Flame_Cult_Envoy]:
  CREATE_HUMANOID_BASE height=character.height proportions="realistic_7_5_heads" pose="A_POSE"
  ADD_CLOTH_LAYERS count=2_to_4 silhouette=character.silhouette material="Dark_Silk"
  ADD_ACCESSORY_SET from_character_spec=true separate_mesh=true
  ADD_FACTION_CREST position="chest_or_belt" material="Tarnished_Dark_Gold"
  ADD_FACE_DETAIL style="high_realistic_wuxia" expression="restrained_authority_or_conflict"
  RETOPOLOGIZE target_tris=character.target_tris animation_ready=true
  UV_UNWRAP texel_density="consistent_2k_to_4k"
  BAKE_NORMAL_AO_CURVATURE from_high_poly=true
  EXPORT format="FBX" include_textures=true naming="JV_CH_<AssetName>_LOD0.fbx"
  CREATE_LOD levels=[LOD1_50_percent, LOD2_20_percent]
```

### 3.3 场景建模通用指令

```Plaintext
BUILD_ENVIRONMENT "Judgment_Hall_Interior":
  CREATE_FLOOR size=(28,18) material="Wet_Black_Stone" add_reflection_variation=true
  CREATE_DAIS position=(0,5,0.8) size=(8,4,1.2) steps=5 material="Wet_Black_Stone"
  CREATE_THRONE position=(0,6.4,1.5) scale=(1.8,1.4,3.0) material_mix=["Black_Lacquer_Wood","Tarnished_Dark_Gold"] motifs=["cloud","scale","eagle"]
  CREATE_PILLARS count=8 height=11 radius=0.35 positions="symmetric_rows" material="Black_Lacquer_Wood"
  CREATE_BEAMS grid="ancient_chinese_roof" material="Black_Lacquer_Wood" gold_trim=true
  CREATE_BANNERS count=8 faction_crests=true cloth_sim_ready=true colors="dark_desaturated"
  CREATE_PROP_PLACEMENT props=["Judge_Desk","Incense_Braziers","Weapon_Racks","Evidence_Box","Scroll_Shelves"] density="ceremonial_not_cluttered"
  CREATE_VOLUMETRIC_FOG density=0.035 color="#2C2A27"
  SET_COLLISION floor=true stairs=true large_props=true
  EXPORT_SCENE modules=true format="FBX+GLB" naming_prefix="JV_ENV_JudgmentHall"
```

```Plaintext
BUILD_ENVIRONMENT "Hall_Exterior":
  CREATE_COURTYARD size=(40,30) wet_stone=true
  CREATE_GATE width=9 height=8 material="Black_Lacquer_Wood" plaque="Tarnished_Dark_Gold"
  CREATE_STAIRS steps=18 width=12 material="Wet_Black_Stone"
  ADD_LANTERNS count=12 light_color="#A66A2C" low_intensity=true
  ADD_RAIN_READY_SURFACES puddles=true dripping_edges=true
  EXPORT_SCENE modules=true naming_prefix="JV_ENV_HallExterior"
```

```Plaintext
FOR_EACH sect_scene IN [Blade_Gate_Fortress, Poison_Sect_Swamp, Buddhist_Monastery, Royal_Eagle_Bureau, Hidden_Sword_Valley, Beggar_Alley, Merchant_Guild_Hall, Flame_Cult_Shrine]:
  BLOCKOUT playable_area="12m_to_25m" camera_paths=["dialogue_intro","establishing_shot"]
  MODEL_PRIMARY_ARCHITECTURE according_to_prompt=true modular=true
  MODEL_3_TO_6_SIGNATURE_PROPS according_to_faction=true
  APPLY_MATERIALS palette="dark_ink_gold" pbr=true
  ADD_ATMOSPHERE fog_or_mist_or_ash=true restrained=true
  OPTIMIZE target_scene_tris="120k_to_300k" collision_meshes=true lod_groups=true
  EXPORT format="FBX+GLB" naming="JV_ENV_<SectScene>_ModuleSet"
```

### 3.4 道具与 UI 3D 元素建模指令

```Plaintext
FOR_EACH prop IN [Command_Token, Judgment_Seal, Verdict_Scroll_Set, Judge_Desk, Evidence_Box, Faction_Crest_Plaques, Weapon_Prop_Set, Reputation_Meter_3D_UI, Dialogue_Frame_3D_UI, Verdict_Button_3D_UI]:
  CREATE_PROP_BASE dimensions=prop.dimensions real_world_scale=true
  ADD_BEVELED_EDGES bevel_radius="0.01_to_0.04m" weighted_normals=true
  ADD_ENGRAVING_OR_RELIEF motifs=prop.motifs depth="0.003_to_0.02m"
  APPLY_PBR_MATERIALS from_global_palette=true
  ADD_WEAR_AND_DIRT masks=["edges","contact_points","engraved_grooves"]
  UV_UNWRAP non_overlapping=true texel_density="consistent_2k"
  CREATE_COLLISION_PROXY simple=true
  EXPORT format="FBX+GLB" naming="JV_PROP_<AssetName>_LOD0"
```

### 3.5 场景摆放验证指令

```Plaintext
CREATE_VALIDATION_SCENE "JV_Blockout_Courtroom_Dialogue"
IMPORT "JV_ENV_JudgmentHall_LOD0"
PLACE_CHARACTER "Jianghu_Lord" at=(0,6.4,1.5) pose="SEATED_COMMANDING"
PLACE_CHARACTER "Blade_Gate_Envoy" at=(-2.2,0,0) pose="KNEELING_ARGUMENT"
PLACE_CHARACTER "Poison_Sect_Envoy" at=(2.2,0,0) pose="STANDING_CALM"
PLACE_CHARACTER "Buddhist_Monk_Envoy" at=(-3.6,-1.8,0) pose="STANDING_STAFF"
PLACE_CHARACTER "Royal_Eagle_Guard_Envoy" at=(3.6,-1.8,0) pose="STANDING_OFFICIAL"
PLACE_CHARACTER "Hidden_Sword_Envoy" at=(0,-2.8,0) pose="STANDING_SILENT"
PLACE_CROWD archetypes=["Petitioner","Scribe","Guard","SectDisciple","Messenger"] count=18 positions="lower_hall_edges"
PLACE_UI_PROP "Verdict_Button_3D_UI" near_camera=true
SET_CAMERA "Main_KV_Camera"
RENDER_STILL output="JV_validation_courtroom_keyshot.png" resolution=(2560,1440)
CHECK_READABILITY silhouettes=true faction_identity=true no_cute_style=true dark_gold_consistency=true
```

---

## 4. 交付优先级建议

1. **P0**：江湖令主、裁决大堂、裁决案台、令牌、判印、5 个核心门派代表。
2. **P1**：补齐 8 个门派代表、UI 3D 元素、外景、背景人物。
3. **P2**：各门派特色场景、道具变体、LOD/碰撞/动画绑定/材质实例化。

## 5. 命名规范

- 角色：`JV_CH_<FactionOrRole>_<Variant>_LOD0.fbx`
- 场景：`JV_ENV_<SceneName>_<ModuleName>_LOD0.fbx`
- 道具：`JV_PROP_<PropName>_LOD0.fbx`
- UI 3D：`JV_UI3D_<ElementName>_LOD0.fbx`
- 材质：`M_JV_<MaterialName>`
- 贴图：`T_JV_<AssetName>_<BaseColor|Normal|Roughness|Metallic|AO>_2K.png`
