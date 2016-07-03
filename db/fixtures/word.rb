require "yaml"

words = YAML.load (<<EOD)
---
-
  - SNS
  - 人と人とのつながりを促進・支援する、コミュニティ型のWebサイトおよびネットサービス。
-
  - IoT
  - コンピュータなどの情報・通信機器だけでなく、世の中に存在する様々な物体（モノ）に通信機能を持たせ、インターネットに接続したり相互に通信することにより、自動認識や自動制御、遠隔計測などを行うこと。
-
  - Mbps
  - データ伝送速度の単位の一つで、1秒間に何百万ビット（何メガビット）のデータを送れるかを表したもの。
-
  - 固定IPアドレス
  - コンピュータの再起動やネットワークの切断・再接続などの影響を受けず、常に同じIPアドレスを利用すること。また、ルータなどが特定の機器に常に同じIPアドレスを割り当てること、及びそのような機能。
-
  - EFI
  - 従来パソコンのハードウェア制御を担ってきたBIOSに代わる、OSとファームウェアのインターフェース仕様。「EFI」は元々Intel社とHewlett-Packard社が提唱していたもので、2007年にUEFIフォーラム（Unified EFI Forum）が設立され、「UEFI」（Unified EFI）と改称された。
EOD

users = %w(新井 井上 臼井 遠藤 太田 金子 菊池)

200.times do
  words.each do |name,desc|
    Word.seed do |s|
      s.name = name
      s.desc = desc
      s.user = users.sample
    end
  end
end
