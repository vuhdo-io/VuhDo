# Contributing to the Wiki

The pages in this wiki live in the [`wiki/` folder](https://github.com/vuhdo-io/VuhDo/tree/midnight/wiki) of the VuhDo repository on the `midnight` branch. Changes are proposed with a pull request. Once a pull request is merged, a GitHub Action publishes the change to the wiki automatically.

Editing the wiki directly is disabled, because direct edits would be overwritten by the next publish.

Everything below can be done in the browser. You don't need to install anything.

## Folder layout

```
wiki/
  Home.md                         Landing page
  _Sidebar.md                     Navigation shown on every page
  _Footer.md                      Footer shown on every page
  Contributing-to-the-Wiki.md     This page
  VuhDo-Classic-FAQ.md            Short standalone pages live at the top level
  Guides/
    Some-Guide-Name/              One folder per guide
      Some-Guide-Name.md          The guide itself
      images/                     Pictures used by that guide only
        some-screenshot.png
```

## Rules

* **Page names must be unique across the whole wiki**, including subfolders. The wiki ignores folders when it names pages, so `Guides/Foo/Foo.md` becomes the page `Foo`.
* Name files as `Title-With-Dashes.md`. The dashes are shown as spaces in the page title.
* Put a guide's pictures in its own `images/` folder. Use lowercase file names without spaces, for example `bouquet-editor.png`.
* Keep images small. Prefer PNG for screenshots and JPG for photos, and crop to what matters. Try to keep each file under about 500 KB.
* Link to images with a relative path: `![Bouquet editor](images/bouquet-editor.png)`.
* Link to other wiki pages by page name: `[[Slash Commands|VuhDo-Slash-Commands]]`.
* When you add a new page, also add it to `_Sidebar.md` and `Home.md`.

## Step by step

### 1. Fork the repository

1. Sign in to GitHub and open [vuhdo-io/VuhDo](https://github.com/vuhdo-io/VuhDo).
2. Click **Fork** in the top right, then **Create fork**. This gives you a personal copy that you can edit freely.

If you already have a fork from earlier, open it and click **Sync fork**, then **Update branch**, so you start from the latest version.

### 2. Make your changes in your fork

* **Edit an existing page:** In your fork, browse to the file under `wiki/` and click the pencil icon (**Edit this file**).
* **Add a new page:** Browse to the folder you want, then click **Add file**, then **Create new file**. To create a new guide folder, type the path into the file name box, for example `Guides/My-New-Guide/My-New-Guide.md`. Typing `/` creates the folders.
* **Add pictures:** Browse to the guide's `images/` folder, then click **Add file**, then **Upload files**, and drag the images in. If the guide has no `images/` folder yet, upload while in the guide's folder and type `images/` in front of the file name. Alternatively, create `images/.gitkeep` first.

Use the **Preview** tab while editing to check how the page will look.

### 3. Commit

Click **Commit changes...** and write a short message, such as `Add guide for setting up auras`. Then choose **Create a new branch for this commit**, give it a name like `wiki-healing-guide`, and commit.

You can keep committing more changes to that same branch.

### 4. Open a pull request

1. GitHub shows a **Compare & pull request** button after you commit. You can also open your fork's **Pull requests** tab and click **New pull request**.
2. Make sure the base is `vuhdo-io/VuhDo` on `midnight`, and the compare side is your fork's branch.
3. Describe what you changed and click **Create pull request**.

### 5. Review and publish

A maintainer reviews the pull request and may leave comments. To address them, commit more changes to the same branch in your fork, and the pull request updates automatically. Once it is merged, the wiki is updated within a minute or two.