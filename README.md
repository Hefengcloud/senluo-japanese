# SENLUO JAPANESE

## 产品计划

## 为例句添加读音

```
Here's a summary of the rules to convert the original Japanese text to the finalized HTML format:

1. Add ruby tags to all characters:
   - For kanji with known readings, use `<ruby>漢字<rt>よみがな</rt></ruby>`
   - For kana or kanji without specific readings, use empty rt tags: `<ruby>かな<rt></rt></ruby>`

2. For emphasized phrases (in this case, "が早いか"):
   - Wrap the entire phrase in a span with class "fancy": `<span class="fancy">...</span>`
   - Continue using ruby tags inside the emphasized span

3. Maintain the original text structure, including spaces and punctuation

4. Apply these rules consistently to the entire sentence, ensuring every character is wrapped in a ruby tag

This approach creates a uniform structure that allows for styling and potentially dynamic display of readings while preserving the original text's meaning and emphasis.
```

The new fomrat:

```
Add furigana to every kanji in the sentence `授業の終わりのチャイムが鳴る が早いか 、彼は教室を飛び出していった。` with the format like `[授業](じゅぎょう)の[終](お)わりの**チャイム**が[鳴](な)る。`
```

然后写一个 Parser 来解析例句。

```
<ruby>授業<rt>じゅぎょう</rt></ruby><ruby>の<rt><rt></ruby><ruby>終<rt>お</rt></ruby><ruby>わりの<span class="fancy">チャイム</span>が<rt></rt></ruby><ruby>鳴<rt>な</rt></ruby><ruby>る<rt></rt></ruby>。
```

