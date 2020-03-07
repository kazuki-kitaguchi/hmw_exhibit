FROM ruby:2.6.5

# mysqlのインストール
RUN apt-get update && apt-get install -y default-mysql-client --no-install-recommends && rm -rf /var/lib/apt/lists/*
# nodejsのインストール
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs --no-install-recommends && apt-get clean && rm -rf /var/lib/apt/lists/*

# 作業ディレクトリの作成と環境変数の設定
RUN mkdir hmw_exhibit
ENV APP_ROOT /hmw_exhibit

# zip解凍ソフトをインストールし、chomedriverの解凍とインストール
RUN apt-get update && apt-get install -y --no-install-recommends unzip && \
    CHROME_DRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    wget -N http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P ~/ && \
    unzip ~/chromedriver_linux64.zip -d ~/ && \
    rm ~/chromedriver_linux64.zip && \
    chown root:root ~/chromedriver && \
    chmod 755 ~/chromedriver && \
    mv ~/chromedriver /usr/bin/chromedriver && \
    sh -c 'wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -' && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get update && apt-get install -y --no-install-recommends google-chrome-stable

# 開発環境の日本語化
RUN apt-get install -y locales task-japanese --no-install-recommends
RUN locale-gen ja_JP.UTF-8
RUN localedef -f UTF-8 -i ja_JP ja_JP
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:jp
ENV LC_ALL ja_JP.UTF-8

# ワークディレクトリを設定
WORKDIR $APP_ROOT

# ホストのGemfileとGemfile.lockをコンテナ側へコピー
COPY Gemfile $APP_ROOT/Gemfile
COPY Gemfile.lock $APP_ROOT/Gemfile.lock

RUN bundle install

#インストールされた内容をコンテナ側へコピー
COPY . $APP_ROOT

