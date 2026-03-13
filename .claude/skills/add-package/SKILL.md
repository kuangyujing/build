---
name: add-package
description: Add a new package to the build system (source, prebuilt, or npm)
user-invocable: true
disable-model-invocation: true
---

新しいパッケージをビルドシステムに追加する: $ARGUMENTS

以下の 7 ステップを順番に実行すること。

---

## ステップ 1: パッケージ情報の確認

`$ARGUMENTS` からパッケージ名を受け取る。以下の情報が不足していれば AskUserQuestion でユーザーに質問する:

- **正式名称とバージョン** (例: jq 1.7.1)
- **タイプ**: `configure` / `prebuilt` / `npm` のいずれか
  - `configure`: GNU Autotools でビルドするパッケージ (`./configure && make`)
  - `prebuilt`: コンパイル済みバイナリを展開・コピーするだけのパッケージ
  - `npm`: npm でグローバルインストールするパッケージ
- **ソースアーカイブ**: `sources/` に既にあるか、ダウンロード URL
- **configure オプション** (configure 型のみ): 特別なオプションがあれば
- **インストール対象ファイル一覧** (prebuilt 型のみ): バイナリ、man ページ、補完ファイルなど

## ステップ 2: ソースの準備

1. `sources/` ディレクトリにアーカイブが存在するか確認する
2. なければ `curl -L -o sources/<filename> <URL>` でダウンロードする
3. ダウンロード後、ファイルサイズが 100 MB を超える場合は GitHub の制限対策として分割する:
   ```bash
   split -b 50m sources/<filename> sources/<filename>.part-
   ```
4. `sources/` 内のアーカイブ名を記録しておく（CLAUDE.md 更新時に使用）

## ステップ 3: ビルド / 展開

タイプに応じて処理を行う。

### configure 型

```bash
cd /Users/k/build/work
tar xf ../sources/<archive>    # or unzip
cd <package-dir>
./configure <options>
make -j"$(sysctl -n hw.ncpu)"
make test    # or make check
```

ビルドやテストが失敗した場合は `config.log` やエラー出力を読んで原因を診断し、ユーザーに報告する。

### prebuilt 型

```bash
cd /Users/k/build/work
tar xf ../sources/<archive>    # or unzip
xattr -dr com.apple.quarantine <extracted-dir>
```

展開後、`--version` や `--help` 等で動作を確認する。

### npm 型

1. `npm` コマンドが存在するか確認する（なければエラー）
2. `npm install -g --dry-run <package>` で依存関係を確認する

## ステップ 4: 衝突チェック

仮インストール先 `/Users/k/build/tmp` を使い、`/usr/local` の既存ファイルとの衝突を検証する。

### configure 型

```bash
mkdir -p /Users/k/build/tmp
make install DESTDIR=/Users/k/build/tmp
```

`tmp/usr/local/` 配下に生成されたファイル一覧を取得し、対応する `/usr/local` のパスに既にファイルが存在するか確認する。

### prebuilt 型

コピー予定の各ファイルについて、`/usr/local` 側に同名ファイルが既に存在するか確認する。DESTDIR は不要。

### npm 型

```bash
npm install -g --prefix /Users/k/build/tmp <package>
```

`tmp/bin/` および `tmp/lib/` 配下のファイル一覧を取得し、`/usr/local` の対応するパスと照合する。

### 衝突発見時の処理

衝突が見つかった場合:
1. 衝突ファイルの一覧を表示する
2. `scripts/uninstall-*.sh` の内容を読み、衝突ファイルがどのパッケージに属するか特定する
3. ユーザーに続行/キャンセルを AskUserQuestion で確認する

### クリーンアップ

衝突チェック完了後、仮インストール先を削除する:

```bash
rm -rf /Users/k/build/tmp
```

## ステップ 5: スクリプト生成

既存スクリプトのパターンに**厳密に**従うこと: `set -euo pipefail`、進捗表示は `echo "==> ..."`、エラーは `>&2`。

### configure 型

- `scripts/build-<name>.sh` — テンプレート: `scripts/build-bash.sh`
- `scripts/uninstall-<name>.sh` — テンプレート: `scripts/uninstall-bash.sh`

### prebuilt 型

- `scripts/install-<name>.sh` — テンプレート: `scripts/install-ripgrep.sh`
- `scripts/uninstall-<name>.sh` — テンプレート: `scripts/uninstall-ripgrep.sh`

### npm 型

- `scripts/install-<name>.sh`: `npm install -g --prefix "$PREFIX"` でインストール
- `scripts/uninstall-<name>.sh`: `npm uninstall -g --prefix "$PREFIX"` でアンインストール

npm 型スクリプトも同じ規約に従う (`set -euo pipefail`, `echo "==> ..."`, エラーは `>&2`)。

### 共通

生成後にすべてのスクリプトに `chmod +x` を実行すること。

## ステップ 6: CLAUDE.md の更新

`/Users/k/build/CLAUDE.md` の以下のセクションを更新する。既存エントリのフォーマットに正確に合わせること。

1. **Directory Structure** (`sources/` と `work/` のツリー): 新しいアーカイブとワークディレクトリのエントリを追加
2. **Packages** テーブル: 新しい行を追加
3. **Build Instructions**: 新しいサブセクション (`### <Package Name>`) を追加。既存のサブセクション（Bash, GNU Coreutils, ripgrep, .NET SDK, Vim）のフォーマットに従う

## ステップ 7: クリーンアップと報告

1. `/Users/k/build/tmp` が残っていれば `rm -rf` で削除する
2. 作成・更新したファイルの一覧を報告する:
   - 作成したスクリプト
   - 更新した CLAUDE.md のセクション
3. 次のステップを案内する:
   - configure 型: `cd /Users/k/build/work/<dir> && sudo make install` または `/build <name>` でリビルド
   - prebuilt 型: `./scripts/install-<name>.sh` でインストール
   - npm 型: `./scripts/install-<name>.sh` でインストール
