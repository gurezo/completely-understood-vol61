```sh
➜  completely-understood-vol61 git:(refactor/firebase) firebase init

     ######## #### ########  ######## ########     ###     ######  ########
     ##        ##  ##     ## ##       ##     ##  ##   ##  ##       ##
     ######    ##  ########  ######   ########  #########  ######  ######
     ##        ##  ##    ##  ##       ##     ## ##     ##       ## ##
     ##       #### ##     ## ######## ########  ##     ##  ######  ########

You're about to initialize a Firebase project in this directory:

  /Users/akihiko.kigure/work/completely-understood-vol61

? Which Firebase features do you want to set up for this directory? Press Space to select features, then Enter to confirm your choices.
 ◯ Genkit: Setup a new Genkit project with Firebase
 ◉ Functions: Configure a Cloud Functions directory and its files
 ◯ App Hosting: Enable web app deployments with App Hosting
❯◉ Hosting: Configure files for Firebase Hosting and (optionally) set up GitHub Action deploys
 ◯ Storage: Configure a security rules file for Cloud Storage
 ◉ Emulators: Set up local emulators for Firebase products
 ◯ Remote Config: Configure a template file for Remote Config

```

---

```sh
✔ Which Firebase features do you want to set up for this directory? Press Space to select features, then Enter to confirm your choices. Functions: Configure a Cloud Functions directory and its files, Hosting: Configure files for Firebase
Hosting and (optionally) set up GitHub Action deploys, Emulators: Set up local emulators for Firebase products

=== Project Setup

First, let's associate this project directory with a Firebase project.
You can create multiple project aliases by running firebase use --add,
but for now we'll just set up a default project.

? Please select an option: (Use arrow keys)
❯ Use an existing project
  Create a new project
  Add Firebase to an existing Google Cloud Platform project
  Don't set up a default project

```

---

```sh
✔ Please select an option: Use an existing project
? Select a default Firebase project for this directory: (Use arrow keys)
❯ completely-understood-vo-a0f23 (completely-understood-vol61)
  lifewood-d627c (lifewood)
```

---

```sh
=== Functions Setup
Let's create a new codebase for your functions.
A directory corresponding to the codebase will be created in your project
with sample code pre-configured.

See https://firebase.google.com/docs/functions/organize-functions for
more information on organizing your functions using codebases.

Functions can be deployed with firebase deploy.

? What language would you like to use to write Cloud Functions?
  JavaScript
❯ TypeScript
  Python

```

---

```sh
Functions can be deployed with firebase deploy.

✔ What language would you like to use to write Cloud Functions? TypeScript
✔ Do you want to use ESLint to catch probable bugs and enforce style? Yes
✔  Wrote functions/package.json
✔  Wrote functions/.eslintrc.js
✔  Wrote functions/tsconfig.dev.json
✔  Wrote functions/tsconfig.json
✔  Wrote functions/src/index.ts
✔  Wrote functions/.gitignore
✔ Do you want to install dependencies with npm now? Yes
⠼
```

---

```sh
=== Hosting Setup

Your public directory is the folder (relative to your project directory) that
will contain Hosting assets to be uploaded with firebase deploy. If you
have a build process for your assets, use your build's output directory.

✔ What do you want to use as your public directory? dist/apps/frontend/browser
✔ Configure as a single-page app (rewrite all urls to /index.html)? No
✔ Set up automatic builds and deploys with GitHub? No
✔  Wrote dist/apps/frontend/browser/404.html
✔ File dist/apps/frontend/browser/index.html already exists. Overwrite? No
i  Skipping write of dist/apps/frontend/browser/index.html
```

---

```sh
=== Emulators Setup
? Which Firebase emulators do you want to set up? Press Space to select emulators, then Enter to confirm your choices.
 ◯ Authentication Emulator
 ◉ Functions Emulator
 ◯ Firestore Emulator
❯◯ Database Emulator
 ◉ Hosting Emulator
 ◯ Pub/Sub Emulator
 ◯ Storage Emulator

```

---

```sh
=== Emulators Setup
✔ Which Firebase emulators do you want to set up? Press Space to select emulators, then Enter to confirm your choices. Functions Emulator, Hosting Emulator
✔ Which port do you want to use for the functions emulator? 5001
✔ Which port do you want to use for the hosting emulator? 5000
✔ Would you like to enable the Emulator UI? Yes
✔ Which port do you want to use for the Emulator UI (leave empty to use any available port)?
✔ Would you like to download the emulators now? Yes

✔  Wrote configuration info to firebase.json
✔  Wrote project information to .firebaserc

✔  Firebase initialization complete!
```

---

```sh
➜  completely-understood-vol61 git:(refactor/firebase) ✗ firebase emulators:start
i  emulators: Starting emulators: functions, hosting, extensions
⚠  hosting: Port 5000 is not open on localhost (127.0.0.1,::1), could not start Hosting Emulator.
⚠  hosting: To select a different host/port, specify that host/port in a firebase.json config file:
      {
        // ...
        "emulators": {
          "hosting": {
            "host": "HOST",
            "port": "PORT"
          }
        }
      }
i  emulators: Shutting down emulators.

Error: Could not start Hosting Emulator, port taken.
➜  completely-understood-vol61 git:(refactor/firebase) ✗


```

---

```diff
{
  "functions": [
    {
      "source": "functions",
      "codebase": "default",
      "ignore": [
        "node_modules",
        ".git",
        "firebase-debug.log",
        "firebase-debug.*.log",
        "*.local"
      ],
      "predeploy": [
        "npm --prefix \"$RESOURCE_DIR\" run lint",
        "npm --prefix \"$RESOURCE_DIR\" run build"
      ]
    }
  ],
  "hosting": {
    "public": "dist/apps/frontend/browser",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"]
  },
  "emulators": {
    "functions": {
      "port": 5001
    },
    "hosting": {
-      "port": 5000
+      "port": 5002
    },
    "ui": {
      "enabled": true
    },
    "singleProjectMode": true
  }
}
```

---

### API 疎通不具合解決

```
ありがとうございます！問題が解決して良かったです。
解決した内容のまとめ
今回の問題は、Firebase Functionsのルーティング設定に関するものでした：
問題の原因：
フロントエンドが/api/doubleエンドポイントにアクセスしようとしていた
しかし、Firebase Functionsではdoubleとapiが別々の関数として定義されていた
そのため、api関数が呼ばれてしまい、期待したdoubleの処理が実行されなかった
解決方法：
api関数内にパスベースのルーティングを実装
/doubleパスへのリクエストを適切に処理するように修正
数値の2倍を計算して返す機能を正しく動作させる
結果：
フロントエンドから送信した数値の2倍が正しく返されるようになりました
今後も同様の問題が発生した場合は、Firebase Functionsのルーティング設定を確認することをお勧めします。何か他にご質問があれば、お気軽にお聞かせください！

```

---

functions を nx ワークスペースに追加

```diff
{
+ "extends": "../tsconfig.base.json",
  "compilerOptions": {
    "module": "NodeNext",
    "esModuleInterop": true,
    "moduleResolution": "nodenext",
    "noImplicitReturns": true,
    "noUnusedLocals": true,
    "outDir": "lib",
    "sourceMap": true,
    "strict": true,
    "target": "es2017"
  },
  "compileOnSave": true,
  "include": [
    "src"
  ],
+ "exclude": [
+   "node_modules",
+   "lib"
  ]
}

```
