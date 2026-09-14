# Adhkar — sunnah.com and quran.com URLs

For every supplication in the app:

* If it is from the Qur'an (`attributionKind: quran`), the `https://quran.com/<surah>/<ayah>` URL parsed from the reference string.
* Otherwise, the `https://sunnah.com/hisn:<N>` URL from an Arabic match against the local hisnmuslim.com feed.
* Otherwise, `NOT FOUND (<old ref>)`.

Snapshot: contentVersion `2`. Feed: `adhkar_api/content/sources/hisn/ar/` (266 entries across 132 chapters).

**Two caveats before you review a NOT FOUND row.**

* **Letter suffixes not resolved.** sunnah.com splits some printed hadiths into `hisn:75a`, `hisn:75b`, `hisn:75c`. The local feed carries one row per printed ID, so the `a`/`b`/`c` variants can only be added by a human check. Where a `hisn:<N>` URL is produced below, the correct final URL may be `hisn:<N>a`.
* **Some supplications do not come from Hisn al-Muslim.** Prophets' du'as get a `quran.com` URL from their surah/ayah reference; Seerah/Companions entries come from other hadith books and get a manual `sunnah.com/<collection>:<N>` (or `/urn/<N>`) URL from the `OVERRIDES` map at the top of this script. Anything still NOT FOUND below is in the 'To find later' table at the end of the file.
* **Ambiguous placement.** Some du'as appear in more than one Hisn chapter — the three Quls sit in `hisn:70` (after prayer) and `hisn:76` (morning/evening) both. The matcher picks one; either URL opens the right recitation, but the chapter context on the page may not match the app's chapter.

Regenerate with `python3 docs/dua_references/build_hisn_urls.py`.

---

## Morning & Evening

### Morning

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `adhkar-1` | <span dir="rtl">الْحَمْدُ لِلَّهِ وَحْدَهُ، وَالصَّلاَةُ وَالسَّلاَمُ عَلَى…</span> | [hisn:75a](https://sunnah.com/hisn:75a) |
| 2 | `adhkar-2` | <span dir="rtl">أَعُوذُ بِاللَّهِ مِنَ الشَّيطَانِ الرَّجِيمِ ﴿اللَّهُ لاَ…</span> | [hisn:75](https://sunnah.com/hisn:75) |
| 3 | `adhkar-4` | <span dir="rtl">قُلْ هُوَ ٱللَّهُ أَحَدٌ، ٱللَّهُ ٱلصَّمَدُ، لَمْ يَلِدْ وَ…</span> | [hisn:76](https://sunnah.com/hisn:76) |
| 4 | `adhkar-5` | <span dir="rtl">قُلْ أَعُوذُ بِرَبِّ ٱلْفَلَقِ، مِن شَرِّ مَا خَلَقَ، وَمِن…</span> | [hisn:70](https://sunnah.com/hisn:70) |
| 5 | `adhkar-6` | <span dir="rtl">قُلْ أَعُوذُ بِرَبِّ ٱلنَّاسِ، مَلِكِ ٱلنَّاسِ، إِلَٰهِ ٱلن…</span> | [hisn:76](https://sunnah.com/hisn:76) |
| 6 | `adhkar-7` | <span dir="rtl">أَصْبَحْنَا وَأَصْبَحَ الْملْكُ لِلَّهِ، وَالْحَمْدُ لِلَّه…</span> | [hisn:77](https://sunnah.com/hisn:77) |
| 7 | `adhkar-9` | <span dir="rtl">اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَح…</span> | [hisn:78](https://sunnah.com/hisn:78) |
| 8 | `adhkar-11` | <span dir="rtl">اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلاَّ أَنْتَ، خَلَقْتَ…</span> | [hisn:79](https://sunnah.com/hisn:79) |
| 9 | `adhkar-12` | <span dir="rtl">اللَّهُمَّ إِنِّي أَصْبَحْتُ أُشْهِدُكَ، وَأُشْهِدُ حَمَلَة…</span> | [hisn:80](https://sunnah.com/hisn:80) |
| 10 | `adhkar-14` | <span dir="rtl">اللَّهُمَّ مَا أَصْبَحَ بِي مِنْ نِعْمَةٍ أَوْ بِأَحَدٍ مِن…</span> | [hisn:81](https://sunnah.com/hisn:81) |
| 11 | `adhkar-16` | <span dir="rtl">اللَّهُمَّ عَافِنِي فِي بَدَنِي، اللَّهُمَّ عَافِنِي فِي سَ…</span> | [hisn:82](https://sunnah.com/hisn:82) |
| 12 | `adhkar-17` | <span dir="rtl">حَسْبِيَ اللَّهُ لاَ إِلَهَ إِلاَّ هُوَ عَلَيهِ تَوَكَّلتُ…</span> | [hisn:83](https://sunnah.com/hisn:83) |
| 13 | `adhkar-18` | <span dir="rtl">اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي ا…</span> | [hisn:84](https://sunnah.com/hisn:84) |
| 14 | `adhkar-19` | <span dir="rtl">اللَّهُمَّ عَالِمَ الغَيْبِ وَالشَّهَادَةِ فَاطِرَ السَّمَو…</span> | [hisn:85](https://sunnah.com/hisn:85) |
| 15 | `adhkar-20` | <span dir="rtl">بِسْمِ اللَّهِ الَّذِي لاَ يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي…</span> | [hisn:86](https://sunnah.com/hisn:86) |
| 16 | `adhkar-21` | <span dir="rtl">رَضِيتُ بِاللَّهِ رَبَّاً، وَبِالْإِسْلاَمِ دِيناً، وَبِمُح…</span> | [hisn:87](https://sunnah.com/hisn:87) |
| 17 | `adhkar-22` | <span dir="rtl">يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغيثُ أَصْلِحْ لِي…</span> | [hisn:88](https://sunnah.com/hisn:88) |
| 18 | `adhkar-23` | <span dir="rtl">أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ رَبِّ الْعَالَمِين…</span> | [hisn:89](https://sunnah.com/hisn:89) |
| 19 | `adhkar-25` | <span dir="rtl">أَصْبَحْنا عَلَى فِطْرَةِ الْإِسْلاَمِ، وَعَلَى كَلِمَةِ ال…</span> | [hisn:90](https://sunnah.com/hisn:90) |
| 20 | `adhkar-27` | <span dir="rtl">اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْماً نَافِعاً، وَرِزْقاً طَ…</span> | [hisn:95](https://sunnah.com/hisn:95) |
| 21 | `adhkar-28` | <span dir="rtl">لاَ إِلَهَ إِلاَّ اللَّهُ، وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ…</span> | [hisn:93](https://sunnah.com/hisn:93) |
| 22 | `adhkar-29` | <span dir="rtl">اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبَيِّنَا مُحَمَّدٍ</span> | [hisn:98](https://sunnah.com/hisn:98) |
| 23 | `adhkar-31` | <span dir="rtl">سُبْحَانَ اللَّهِ وَبِحَمْدِهِ: عَدَدَ خَلْقِهِ، وَرِضَا نَ…</span> | [hisn:94](https://sunnah.com/hisn:94) |
| 24 | `adhkar-32` | <span dir="rtl">لاَ إِلَهَ إِلاَّ اللَّهُ، وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ…</span> | [hisn:93](https://sunnah.com/hisn:93) |
| 25 | `adhkar-33` | <span dir="rtl">أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ</span> | [hisn:96](https://sunnah.com/hisn:96) |
| 26 | `adhkar-34` | <span dir="rtl">سُبْحَانَ اللَّهِ وَبِحَمْدِهِ</span> | [hisn:91](https://sunnah.com/hisn:91) |

### Evening

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `adhkar-1` | <span dir="rtl">الْحَمْدُ لِلَّهِ وَحْدَهُ، وَالصَّلاَةُ وَالسَّلاَمُ عَلَى…</span> | [hisn:75a](https://sunnah.com/hisn:75a) |
| 2 | `adhkar-2` | <span dir="rtl">أَعُوذُ بِاللَّهِ مِنَ الشَّيطَانِ الرَّجِيمِ ﴿اللَّهُ لاَ…</span> | [hisn:75](https://sunnah.com/hisn:75) |
| 3 | `adhkar-3` | <span dir="rtl">أَعُوذُ بِاللَّهِ مِنَ الشَّيطَانِ الرَّجِيمِ ﴿آمَنَ الرَّس…</span> | [hisn:101](https://sunnah.com/hisn:101) |
| 4 | `adhkar-4` | <span dir="rtl">قُلْ هُوَ ٱللَّهُ أَحَدٌ، ٱللَّهُ ٱلصَّمَدُ، لَمْ يَلِدْ وَ…</span> | [hisn:76](https://sunnah.com/hisn:76) |
| 5 | `adhkar-5` | <span dir="rtl">قُلْ أَعُوذُ بِرَبِّ ٱلْفَلَقِ، مِن شَرِّ مَا خَلَقَ، وَمِن…</span> | [hisn:70](https://sunnah.com/hisn:70) |
| 6 | `adhkar-6` | <span dir="rtl">قُلْ أَعُوذُ بِرَبِّ ٱلنَّاسِ، مَلِكِ ٱلنَّاسِ، إِلَٰهِ ٱلن…</span> | [hisn:76](https://sunnah.com/hisn:76) |
| 7 | `adhkar-8` | <span dir="rtl">أمسينا وأمسى الملك للَّه، وَالْحَمْدُ لِلَّهِ، لاَ إِلَهَ إ…</span> | [hisn:77](https://sunnah.com/hisn:77) |
| 8 | `adhkar-10` | <span dir="rtl">اللَّهمَّ بِكَ أمسَينا وبِكَ أصبَحنا وبِكَ نَحيا وبِكَ نموت…</span> | [hisn:78](https://sunnah.com/hisn:78) |
| 9 | `adhkar-11` | <span dir="rtl">اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلاَّ أَنْتَ، خَلَقْتَ…</span> | [hisn:79](https://sunnah.com/hisn:79) |
| 10 | `adhkar-13` | <span dir="rtl">اللَّهم إني أمسيت أُشْهِدُكَ، وَأُشْهِدُ حَمَلَةَ عَرْشِكَ،…</span> | [hisn:80](https://sunnah.com/hisn:80) |
| 11 | `adhkar-15` | <span dir="rtl">اللَّهم ما أمسى بي مِنْ نِعْمَةٍ أَوْ بِأَحَدٍ مِنْ خَلْقِك…</span> | [hisn:81](https://sunnah.com/hisn:81) |
| 12 | `adhkar-16` | <span dir="rtl">اللَّهُمَّ عَافِنِي فِي بَدَنِي، اللَّهُمَّ عَافِنِي فِي سَ…</span> | [hisn:82](https://sunnah.com/hisn:82) |
| 13 | `adhkar-17` | <span dir="rtl">حَسْبِيَ اللَّهُ لاَ إِلَهَ إِلاَّ هُوَ عَلَيهِ تَوَكَّلتُ…</span> | [hisn:83](https://sunnah.com/hisn:83) |
| 14 | `adhkar-18` | <span dir="rtl">اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي ا…</span> | [hisn:84](https://sunnah.com/hisn:84) |
| 15 | `adhkar-19` | <span dir="rtl">اللَّهُمَّ عَالِمَ الغَيْبِ وَالشَّهَادَةِ فَاطِرَ السَّمَو…</span> | [hisn:85](https://sunnah.com/hisn:85) |
| 16 | `adhkar-20` | <span dir="rtl">بِسْمِ اللَّهِ الَّذِي لاَ يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي…</span> | [hisn:86](https://sunnah.com/hisn:86) |
| 17 | `adhkar-21` | <span dir="rtl">رَضِيتُ بِاللَّهِ رَبَّاً، وَبِالْإِسْلاَمِ دِيناً، وَبِمُح…</span> | [hisn:87](https://sunnah.com/hisn:87) |
| 18 | `adhkar-22` | <span dir="rtl">يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغيثُ أَصْلِحْ لِي…</span> | [hisn:88](https://sunnah.com/hisn:88) |
| 19 | `adhkar-24` | <span dir="rtl">أَمْسَيْنا وَأَمْسَى الْمُلْكُ للهِ رَبِّ الْعَالَمَيْنِ، ا…</span> | [hisn:89](https://sunnah.com/hisn:89) |
| 20 | `adhkar-26` | <span dir="rtl">أمسينا على فطرة الإسلام، وَعَلَى كَلِمَةِ الْإِخْلاَصِ، وَع…</span> | [hisn:90](https://sunnah.com/hisn:90) |
| 21 | `adhkar-28` | <span dir="rtl">لاَ إِلَهَ إِلاَّ اللَّهُ، وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ…</span> | [hisn:93](https://sunnah.com/hisn:93) |
| 22 | `adhkar-29` | <span dir="rtl">اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبَيِّنَا مُحَمَّدٍ</span> | [hisn:98](https://sunnah.com/hisn:98) |
| 23 | `adhkar-30` | <span dir="rtl">أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَل…</span> | [hisn:216](https://sunnah.com/hisn:216) |
| 24 | `adhkar-34` | <span dir="rtl">سُبْحَانَ اللَّهِ وَبِحَمْدِهِ</span> | [hisn:91](https://sunnah.com/hisn:91) |

---

## In the Prayer

### Opening the prayer

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-27` | <span dir="rtl">اللَّهُمَّ بَاعِدْ بَيْنِي وَبَيْنَ خَطَايَايَ كَمَا بَاعَد…</span> | [hisn:27](https://sunnah.com/hisn:27) |
| 2 | `hisn-28` | <span dir="rtl">سُبْحانَكَ اللَّهُمَّ وَبِحَمْدِكَ، وَتَبارَكَ اسْمُكَ، وَت…</span> | [hisn:28](https://sunnah.com/hisn:28) |
| 3 | `hisn-29` | <span dir="rtl">وَجَّهْتُ وَجْهِيَ لِلَّذِي فَطَرَ السَّمَوَاتِ وَالأَرْضَ…</span> | [hisn:29](https://sunnah.com/hisn:29) |
| 4 | `hisn-30` | <span dir="rtl">اللَّهُمَّ رَبَّ جِبْرَائِيلَ، وَمِيْكَائِيلَ، وَإِسْرَافِي…</span> | [hisn:30](https://sunnah.com/hisn:30) |
| 5 | `hisn-31` | <span dir="rtl">اللَّهُ أَكْبَرُ كَبِيرَاً، اللَّهُ أَكْبَرُ كَبِيراً، اللّ…</span> | [hisn:31](https://sunnah.com/hisn:31) |
| 6 | `hisn-32` | <span dir="rtl">اللَّهُمَّ لَكَ الْحَمْدُ، أَنْتَ نُورُ السَّمَوَاتِ وَالأَ…</span> | [hisn:32](https://sunnah.com/hisn:32) |

### In ruku'

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-33` | <span dir="rtl">سُبْحانَ رَبِّيَ الْعَظِيمِ. ثلاث مرَّاتٍ.</span> | [hisn:33](https://sunnah.com/hisn:33) |
| 2 | `hisn-34` | <span dir="rtl">سُبْحَانَكَ اللَّهُمَّ رَبَّنَا وَبِحَمْدِكَ، اللَّهُمَّ اغ…</span> | [hisn:34](https://sunnah.com/hisn:34) |
| 3 | `hisn-35` | <span dir="rtl">سُبُّوُحٌ، قُدُّوسٌ، رَبُّ المَلاَئِكَةِ وَالرُّوحِ.</span> | [hisn:35](https://sunnah.com/hisn:35) |
| 4 | `hisn-36` | <span dir="rtl">اللَّهُمَّ لَكَ رَكَعْتُ، وَبِكَ آمَنْتُ، وَلَكَ أَسْلَمْتُ…</span> | [hisn:36](https://sunnah.com/hisn:36) |
| 5 | `hisn-37` | <span dir="rtl">سُبْحَانَ ذِي الْجَبَرُوتِ، وَالْمَلَكُوتِ، وَالْكِبْرِيَاء…</span> | [hisn:37](https://sunnah.com/hisn:37) |

### Rising from ruku'

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-38` | <span dir="rtl">سَمِعَ اللَّهُ لِمَنْ حَمِدَهُ.</span> | [hisn:38](https://sunnah.com/hisn:38) |
| 2 | `hisn-39` | <span dir="rtl">رَبَّنَا وَلَكَ الْحَمْدُ، حَمْداً كَثيراً طَيِّباً مُبارَك…</span> | [hisn:39](https://sunnah.com/hisn:39) |
| 3 | `hisn-40` | <span dir="rtl">مِلْءَ السَّمَوَاتِ وَمِلْءَ الأَرْضِ، وَمَا بَيْنَهُمَا، و…</span> | [hisn:40](https://sunnah.com/hisn:40) |

### In sujud

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-41` | <span dir="rtl">سُبْحَانَ رَبِّيَ الأَعْلَى ثلاث مرَّاتٍ.</span> | [hisn:41](https://sunnah.com/hisn:41) |
| 2 | `hisn-42` | <span dir="rtl">سُبْحَانَكَ اللَّهُمَّ رَبَّنَا وَبِحَمْدِكَ، اللَّهُمَّ اغ…</span> | [hisn:34](https://sunnah.com/hisn:34) |
| 3 | `hisn-43` | <span dir="rtl">سُبوحٌ، قُدُّوسٌ، رَبُّ الْمَلَائِكَةِ وَالرُّوحِ.</span> | [hisn:35](https://sunnah.com/hisn:35) |
| 4 | `hisn-44` | <span dir="rtl">اللَّهُمَّ لَكَ سَجَدْتُ وَبِكَ آمَنْتُ، وَلَكَ أَسْلَمْتُ،…</span> | [hisn:44](https://sunnah.com/hisn:44) |
| 5 | `hisn-45` | <span dir="rtl">سُبْحَانَ ذِي الْجَبَرُوتِ، وَالْمَلَكُوتِ، وَالْكِبْرِيَاء…</span> | [hisn:37](https://sunnah.com/hisn:37) |
| 6 | `hisn-46` | <span dir="rtl">اللَّهُمَّ اغْفِرْ لِي ذَنْبِي كُلَّهُ: دِقَّهُ وَجِلَّهُ،…</span> | [hisn:46](https://sunnah.com/hisn:46) |
| 7 | `hisn-47` | <span dir="rtl">اللَّهُمَّ إِنِّي أَعُوذُ بِرِضَاكَ مِنْ سَخَطِكَ، وَبِمُعَ…</span> | [hisn:47](https://sunnah.com/hisn:47) |

### Between the two prostrations

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-48` | <span dir="rtl">رَبِّ اغْفِرْ لِي، رَبِّ اغْفِرْ لِي.</span> | [hisn:48](https://sunnah.com/hisn:48) |
| 2 | `hisn-49` | <span dir="rtl">اللَّهُمَّ اغْفِرْ لِي، وَارْحَمْنِي، وَاهْدِنِي، وَاجْبُرْ…</span> | [hisn:49](https://sunnah.com/hisn:49) |

### The tashahhud

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-52` | <span dir="rtl">التَّحِيَّاتُ لِلَّهِ، وَالصَّلَواتُ، وَالطَّيِّباتُ، السَّ…</span> | [hisn:52](https://sunnah.com/hisn:52) |

### Blessings on the Prophet ﷺ

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-53` | <span dir="rtl">اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ، وَعَلَى آلِ مُحَمَّدٍ، كَ…</span> | [hisn:53](https://sunnah.com/hisn:53) |
| 2 | `hisn-54` | <span dir="rtl">اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى أَزْوَاجِهِ وَذُرّ…</span> | [hisn:54](https://sunnah.com/hisn:54) |

### Before the salam

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-55` | <span dir="rtl">اللَّهُــمَّ إِنِّي أَعُوذُ بِكَ مِنْ عَذَابِ الْقَبْرِ، وَ…</span> | [hisn:55](https://sunnah.com/hisn:55) |
| 2 | `hisn-56` | <span dir="rtl">اللَّهُمَّ إِنِّي أَعوذُ بِكَ مِنْ عَذَابِ الْقَبْرِ، وَأَع…</span> | [hisn:56](https://sunnah.com/hisn:56) |
| 3 | `hisn-57` | <span dir="rtl">اللَّهُمَّ إِنِّي ظَلَمْتُ نَفْسِي ظُلْماً كَثِيراً، وَلاَ…</span> | [hisn:57](https://sunnah.com/hisn:57) |
| 4 | `hisn-58` | <span dir="rtl">اللَّهُمَّ اغْفِرْ لِي مَا قَدَّمْتُ، وَمَا أَخَّرْتُ، وَمَ…</span> | [hisn:58](https://sunnah.com/hisn:58) |
| 5 | `hisn-59` | <span dir="rtl">اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ، وَشُكْرِكَ، وَحُسْنِ عِ…</span> | [hisn:59](https://sunnah.com/hisn:59) |
| 6 | `hisn-60` | <span dir="rtl">اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْبُخْلِ، وَأَعوذُ بِك…</span> | [hisn:60](https://sunnah.com/hisn:60) |
| 7 | `hisn-61` | <span dir="rtl">اللَّهُمَّ إِنِّي أَسْأَلُكَ الْجَنَّةَ وَأَعُوذُ بِكَ مِنَ…</span> | [hisn:61](https://sunnah.com/hisn:61) |
| 8 | `hisn-62` | <span dir="rtl">اللَّهُمَّ بِعِلْمِكَ الغَيْبَ وَقُدْرَتِكَ عَلَى الْخَلقِ…</span> | [hisn:62](https://sunnah.com/hisn:62) |
| 9 | `hisn-63` | <span dir="rtl">اللَّهُمَّ إِنِّي أَسْأَلُكَ يَا أَللَّهُ بِأَنَّكَ الْوَاح…</span> | [hisn:63](https://sunnah.com/hisn:63) |
| 10 | `hisn-64` | <span dir="rtl">اللَّهُمَّ إِنِّي أَسْأَلُكَ بِأَنَّ لَكَ الْحَمْدَ لَا إِل…</span> | [hisn:64](https://sunnah.com/hisn:64) |
| 11 | `hisn-65` | <span dir="rtl">اللَّهُمَّ إِنِّي أَسْأَلُكَ بِأَنَّي أَشْهَدُ أَنَّكَ أَنْ…</span> | [hisn:65](https://sunnah.com/hisn:65) |

### After the prayer

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-66` | <span dir="rtl">أَسْتَغْفِرُ اللَّهَ (ثَلاَثَاً) اللَّهُمَّ أَنْتَ السَّلاَ…</span> | [hisn:66](https://sunnah.com/hisn:66) |
| 2 | `hisn-67` | <span dir="rtl">لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ ا…</span> | [hisn:67](https://sunnah.com/hisn:67) |
| 3 | `hisn-68` | <span dir="rtl">لَا إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ ا…</span> | [hisn:68](https://sunnah.com/hisn:68) |
| 4 | `hisn-69` | <span dir="rtl">سُبْحَانَ اللَّهِ، وَالْحَمْدُ لِلَّهِ، وَاللَّهُ أَكْبَرُ…</span> | [hisn:69](https://sunnah.com/hisn:69) |
| 5 | `hisn-70` | <span dir="rtl">بسم الله الرحمن الرحيم ﴿قُلْ هُوَ اللَّهُ أَحَدٌ* اللَّهُ ا…</span> | [hisn:70](https://sunnah.com/hisn:70) |
| 6 | `hisn-71` | <span dir="rtl">﴿اللَّهُ لاَ إِلَهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ لاَ تَ…</span> | [hisn:71](https://sunnah.com/hisn:71) |
| 7 | `hisn-72` | <span dir="rtl">لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ ا…</span> | [hisn:72](https://sunnah.com/hisn:72) |
| 8 | `hisn-73` | <span dir="rtl">اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْماً نافِعاً، وَرِزْقاً طَي…</span> | [hisn:73](https://sunnah.com/hisn:73) |

### The prostration of recitation

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-50` | <span dir="rtl">سَجَدَ وَجْهِيَ لِلَّذِي خَلَقَهُ، وَشَقَّ سَمْعَهُ وَبَصَر…</span> | [hisn:50](https://sunnah.com/hisn:50) |
| 2 | `hisn-51` | <span dir="rtl">اللَّهُمَّ اكْتُبْ لِي بِهَا عِنْدَكَ أَجْراً، وَضَعْ عَنِّ…</span> | [hisn:51](https://sunnah.com/hisn:51) |

### Qunut in the Witr

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-116` | <span dir="rtl">اللَّهُمَّ اهْدِنِي فِيمَنْ هَدَيْتَ، وَعَافِنِي فِيمَنْ عَ…</span> | [hisn:116](https://sunnah.com/hisn:116) |
| 2 | `hisn-117` | <span dir="rtl">اللَّهُمَّ إِنِّي أَعُوذُ بِرِضَاكَ مِنْ سَخَطِكَ، وَبِمُعَ…</span> | [hisn:47](https://sunnah.com/hisn:47) |
| 3 | `hisn-118` | <span dir="rtl">اللَّهُمَّ إِيَّاكَ نعْبُدُ، وَلَكَ نُصَلِّي وَنَسْجُدُ، وَ…</span> | [hisn:118](https://sunnah.com/hisn:118) |

### After the Witr

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-119` | <span dir="rtl">سُبْحَانَ المَلِكِ القُدُّوسِ ثلاثَ مرَّاتٍ والثَّالِثَةُ ي…</span> | [hisn:119](https://sunnah.com/hisn:119) |

### Hearing the adhan

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-22` | <span dir="rtl">يَقُولُ مِثْلَ مَا يَقُولُ المُؤَذِّنُ إِلاَّ فِي حَيَّ عَل…</span> | [hisn:22](https://sunnah.com/hisn:22) |
| 2 | `hisn-23` | <span dir="rtl">يَقُولُ: وَأَنَا أَشْهَدُ أَنْ لاَ إِلَهَ إِلاَّ اللَّهُ وَ…</span> | [hisn:23](https://sunnah.com/hisn:23) |
| 3 | `hisn-24` | <span dir="rtl">يُصَلِّي عَلَى النَّبِيِّ صلى الله عليه وسلم بَعْدَ فَرَاغِ…</span> | [hisn:24](https://sunnah.com/hisn:24) |
| 4 | `hisn-25` | <span dir="rtl">يَقُولُ: اللَّهُمَّ رَبَّ هَذِهِ الدَّعْوَةِ التَّامَّةِ، و…</span> | [hisn:25](https://sunnah.com/hisn:25) |
| 5 | `hisn-26` | <span dir="rtl">يَدْعُو لِنَفسِهِ بَيْنَ الْأَذَانِ وَالْإِقَامَةِ فَإِنَّ…</span> | [hisn:26](https://sunnah.com/hisn:26) |

---

## Through the Day

### Waking up

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-1` | <span dir="rtl">( الْحَمْدُ للَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا…</span> | [hisn:1](https://sunnah.com/hisn:1) |
| 2 | `hisn-2` | <span dir="rtl">( لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَريكَ لَهُ، لَهُ…</span> | [hisn:2](https://sunnah.com/hisn:2) |
| 3 | `hisn-3` | <span dir="rtl">( الْحَمْدُ لِلَّهِ الَّذِي عَافَانِي فِي جَسَدِي، وَرَدَّ…</span> | [hisn:3](https://sunnah.com/hisn:3) |
| 4 | `hisn-4` | <span dir="rtl">﴿ إِنَّ فِي خَلْقِ السَّمَوَاتِ وَالأَرْضِ وَاخْتِلاَفِ الل…</span> | [hisn:4](https://sunnah.com/hisn:4) |

### Getting dressed

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-5` | <span dir="rtl">(الْحَمْدُ للَّهِ الَّذِي كَسَانِي هَذَا (الثَّوْبَ) وَرَزَ…</span> | [hisn:5](https://sunnah.com/hisn:5) |

### Putting on new clothes

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-6` | <span dir="rtl">( اللَّهُمَّ لَكَ الْحَمْدُ أَنْتَ كَسَوْتَنِيهِ، أَسْأَلُك…</span> | [hisn:6](https://sunnah.com/hisn:6) |

### For someone in new clothes

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-7` | <span dir="rtl">(تُبْلِي وَيُخْلِفُ اللَّهُ تَعَالَى)</span> | [hisn:7](https://sunnah.com/hisn:7) |
| 2 | `hisn-8` | <span dir="rtl">(اِلْبَسْ جَدِيداً وَعِشْ حَمِيداً وَمُتْ شَهِيداً).</span> | [hisn:8](https://sunnah.com/hisn:8) |

### Undressing

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-9` | <span dir="rtl">(بِسْمِ اللَّهِ).</span> | [hisn:9](https://sunnah.com/hisn:9) |

### Entering the bathroom

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-10` | <span dir="rtl">([بِسْمِ اللَّهِ] اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُ…</span> | [hisn:10](https://sunnah.com/hisn:10) |

### Leaving the bathroom

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-11` | <span dir="rtl">(غُفْرَانَكَ).</span> | [hisn:11](https://sunnah.com/hisn:11) |

### Before wudu

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-12` | <span dir="rtl">(بِسْمِ اللَّهِ).</span> | [hisn:9](https://sunnah.com/hisn:9) |

### After wudu

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-13` | <span dir="rtl">(أَشْهَدُ أَنْ لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِي…</span> | [hisn:13](https://sunnah.com/hisn:13) |
| 2 | `hisn-14` | <span dir="rtl">(اللَّهُمَّ اجْعَلْنِي مِنَ التَّوَّابِينَ وَاجْعَلْنِي مِن…</span> | [hisn:14](https://sunnah.com/hisn:14) |
| 3 | `hisn-15` | <span dir="rtl">(سُبْحانَكَ اللَّهُمَّ وَبِحَمْدِكَ، أَشْهَدُ أَنْ لاَ إِلَ…</span> | [hisn:15](https://sunnah.com/hisn:15) |

### Leaving the house

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-16` | <span dir="rtl">(بِسْمِ اللَّهِ، تَوَكَّلْتُ عَلَى اللَّهِ، وَلَاَ حَوْلَ و…</span> | [hisn:16](https://sunnah.com/hisn:16) |
| 2 | `hisn-17` | <span dir="rtl">(اللَّهُمَّ إِنِّي أَعُوذُ بِكَ أَنْ أَضِلَّ، أَوْ أُضَلَّ،…</span> | [hisn:17](https://sunnah.com/hisn:17) |

### Entering the house

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-18` | <span dir="rtl">(بِسْمِ اللَّهِ وَلَجْنَا، وَبِسْمِ اللَّهِ خَرَجْنَا، وَعَ…</span> | [hisn:18](https://sunnah.com/hisn:18) |

### Setting out for the mosque

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-19` | <span dir="rtl">(اللَّهُمَّ اجْعَلْ فِي قَلْبِي نُوراً، وَفِي لِسَانِي نُور…</span> | [hisn:19](https://sunnah.com/hisn:19) |

### Entering the mosque

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-20` | <span dir="rtl">(يَبْدَأُ بِرِجْلِهِ الْيُمْنَى) ، وَيَقُولُ: أَعُوذُ بِالل…</span> | [hisn:20](https://sunnah.com/hisn:20) |

### Leaving the mosque

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-21` | <span dir="rtl">يَبْدَأُ بِرِجْلِهِ الْيُسْرَى  وَيَقُولُ: بِسْمِ اللَّهِ و…</span> | [hisn:21](https://sunnah.com/hisn:21) |

### Before sleeping

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-99` | <span dir="rtl">يَجْمَعُ كَفَّيْهِ ثُمَّ يَنْفُثُ فِيهِمَا فَيَقْرَأُ فِيهِ…</span> | [hisn:99](https://sunnah.com/hisn:99) |
| 2 | `hisn-100` | <span dir="rtl">﴿اللَّهُ لاَ إِلَهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ لاَ تَ…</span> | [hisn:100](https://sunnah.com/hisn:100) |
| 3 | `hisn-101` | <span dir="rtl">﴿آمَنَ الرَّسُولُ بِمَا أُنزِلَ إِلَيْهِ مِن رَّبِّهِ وَالْ…</span> | [hisn:101](https://sunnah.com/hisn:101) |
| 4 | `hisn-102` | <span dir="rtl">بِاسْمِكَ رَبِّي وَضَعْتُ جَنْبِي، وَبِكَ أَرْفَعُهُ، فَإِن…</span> | [hisn:102](https://sunnah.com/hisn:102) |
| 5 | `hisn-103` | <span dir="rtl">اللَّهُمَّ إِنَّكَ خَلَقْتَ نَفْسِي وَأَنْتَ تَوَفَّاهَا، ل…</span> | [hisn:103](https://sunnah.com/hisn:103) |
| 6 | `hisn-104` | <span dir="rtl">اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ.</span> | [hisn:104](https://sunnah.com/hisn:104) |
| 7 | `hisn-105` | <span dir="rtl">بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا.</span> | [hisn:105](https://sunnah.com/hisn:105) |
| 8 | `hisn-106` | <span dir="rtl">سُبْحَانَ اللَّهِ (ثلاثاً وثلاثين) وَالْحَمْدُ لِلَّهِ (ثلا…</span> | [hisn:106](https://sunnah.com/hisn:106) |
| 9 | `hisn-107` | <span dir="rtl">اللَّهُمَّ رَبَّ السَّمَوَاتِ السَّبْعِ وَرَبَّ الأَرْضِ، و…</span> | [hisn:107](https://sunnah.com/hisn:107) |
| 10 | `hisn-108` | <span dir="rtl">الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا، وَكَفَانَ…</span> | [hisn:108](https://sunnah.com/hisn:108) |
| 11 | `hisn-109` | <span dir="rtl">اللَّهُمَّ عَالِمَ الغَيْبِ وَالشَّهَادَةِ فَاطِرَ السَّمَو…</span> | [hisn:85](https://sunnah.com/hisn:85) |
| 12 | `hisn-110` | <span dir="rtl">يَقْرَأُ ﴿الم﴾ تَنْزِيلَ السَّجْدَة ِ،  وَتَبَارَكَ الَّذي…</span> | [hisn:110](https://sunnah.com/hisn:110) |
| 13 | `hisn-111` | <span dir="rtl">اللَّهُمَّ أَسْلَمْتُ نَفْسِي إِلَيْكَ، وَفَوَّضْتُ أَمْرِي…</span> | [hisn:111](https://sunnah.com/hisn:111) |

### Turning over in the night

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-112` | <span dir="rtl">لاَ إِلَهَ إِلاَّ اللَّهُ الْوَاحِدُ الْقَهّارُ، رَبُّ السّ…</span> | [hisn:112](https://sunnah.com/hisn:112) |

### Afraid or lonely at night

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-113` | <span dir="rtl">أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ غَضَبِهِ وَعِ…</span> | [hisn:113](https://sunnah.com/hisn:113) |

### After a bad dream

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-114` | <span dir="rtl">[ (يَنْفُثُ عَنْ يَسَارِهِ (ثلاثاً - (يَسْتَعِيذُ بِاللَّهِ…</span> | [hisn:114](https://sunnah.com/hisn:114) |
| 2 | `hisn-115` | <span dir="rtl">ويَقُومُ يُصَلِّي إِنْ أَرَادَ ذَلِكَ.</span> | [hisn:115](https://sunnah.com/hisn:115) |

### Congratulating new parents

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-145` | <span dir="rtl">بَارَكَ اللَّهُ لَكَ فِي الْمَوْهُوبِ لَكَ، وَشَكَرْتَ الْو…</span> | [hisn:145](https://sunnah.com/hisn:145) |

### Seeking protection for children

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-146` | <span dir="rtl">كَانَ رَسُولُ اللَّهِ صلى الله عليه وسلم يُعَوِّذُ الحَسَنَ…</span> | [hisn:146](https://sunnah.com/hisn:146) |

### When the wind blows

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-166` | <span dir="rtl">اللَّهُمَّ إِنِّي أَسْــــــأَلُكَ خَيْرَهَا، وَأَعُوذُ بِك…</span> | [hisn:166](https://sunnah.com/hisn:166) |
| 2 | `hisn-167` | <span dir="rtl">اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَهَا، وَخَيْرَ مَا فِيهَا…</span> | [hisn:167](https://sunnah.com/hisn:167) |

### When it thunders

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-168` | <span dir="rtl">سُبْحَانَ الَّذِي يُسَبِّحُ الرَّعْدُ بِحَمْدِهِ وَالْمَلاَ…</span> | [hisn:168](https://sunnah.com/hisn:168) |

### Asking for rain

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-169` | <span dir="rtl">اللَّهُمَّ اسْقِنَا غَيْثاً مُغِيثاً مَرِيئاً مَرِيعاً، نَا…</span> | [hisn:169](https://sunnah.com/hisn:169) |
| 2 | `hisn-170` | <span dir="rtl">اللَّهُمَّ أَغِثْنَا، اللَّهُمَّ أَغِثْنَا، اللَّهُمَّ أَغِ…</span> | [hisn:170](https://sunnah.com/hisn:170) |
| 3 | `hisn-171` | <span dir="rtl">اللَّهُمَّ اسْقِ عِبَادَكَ، وَبَهَائِمَكَ، وَانْشُرْ رَحْمَ…</span> | [hisn:171](https://sunnah.com/hisn:171) |

### When it rains

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-172` | <span dir="rtl">اللَّهُمَّ صَيِّباً نَافِعاً.</span> | [hisn:172](https://sunnah.com/hisn:172) |

### After the rain

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-173` | <span dir="rtl">مُطِرْنَا بِفَضْلِ اللَّهِ وَرَحْمَتِهِ.</span> | [hisn:173](https://sunnah.com/hisn:173) |

### When the rain will not stop

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-174` | <span dir="rtl">اللَّهُمَّ حَوَالَيْنَا وَلاَ عَلَيْنَا، اللَّهُمَّ عَلَى ا…</span> | [hisn:174](https://sunnah.com/hisn:174) |

### Sighting the new moon

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-175` | <span dir="rtl">اللَّهُ أَكْبَرُ، اللَّهُمَّ أَهِلَّهُ عَلَيْنَا بِالْأَمْن…</span> | [hisn:175](https://sunnah.com/hisn:175) |

### Breaking the fast

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-176` | <span dir="rtl">ذَهَبَ الظَّمَأُ وَابْتَلَّتِ العُرُوقُ، وَثَبَتَ الْأَجْرُ…</span> | [hisn:176](https://sunnah.com/hisn:176) |
| 2 | `hisn-177` | <span dir="rtl">اللَّهُمَّ إِنِّي أَسْأَلُكَ بِرَحْمَتِكَ الَّتِي وَسِعَتْ…</span> | [hisn:177](https://sunnah.com/hisn:177) |

### Before eating

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-178` | <span dir="rtl">إِذَا أَكَلَ أَحَدُكُمْ طَعَاماً فَلْيَقُلْ بِسْمِ اللَّهِ،…</span> | [hisn:178](https://sunnah.com/hisn:178) |
| 2 | `hisn-179` | <span dir="rtl">مَنْ أَطْعَمَهُ اللَّهُ الطَّعَامَ فَلْيَقُلْ: اللَّهُمَّ ب…</span> | [hisn:179](https://sunnah.com/hisn:179) |

### After eating

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-180` | <span dir="rtl">الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا، وَرَزَقَنِيهِ،…</span> | [hisn:180](https://sunnah.com/hisn:180) |
| 2 | `hisn-181` | <span dir="rtl">الْحَمْدُ لِلَّهِ حَمْداً كَثِيراً طَيِّباً مُبَارَكاً فِيه…</span> | [hisn:181](https://sunnah.com/hisn:181) |

### A guest's du'a for the host

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-182` | <span dir="rtl">اللَّهُمَّ بَارِكْ لَهُمْ فِيمَا رَزَقْتَهُم، وَاغْفِرْ لَه…</span> | [hisn:182](https://sunnah.com/hisn:182) |

### For someone who gives you a drink

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-183` | <span dir="rtl">اللَّهُمَّ أَطْعِمْ مَنْ أَطْعَمَنِي، وَاسْقِ مَنْ سَقَانِي.</span> | [hisn:183](https://sunnah.com/hisn:183) |

### For a family who feeds you at iftar

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-184` | <span dir="rtl">أَفْطَرَ عِنْدَكُمُ الصَّائِمُونَ، وَأَكَلَ طَعَامَكُمُ الْ…</span> | [hisn:184](https://sunnah.com/hisn:184) |

### Declining food while fasting

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-185` | <span dir="rtl">إِذَا دُعِيَ أَحَدُكُمْ فَلْيُجِبْ، فَإِنْ كَانَ صَائِماً ف…</span> | [hisn:185](https://sunnah.com/hisn:185) |

### When someone is rude while you fast

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-186` | <span dir="rtl">إِنِّي صَائِمٌ، إِنِّي صَائِمٌ.</span> | [hisn:186](https://sunnah.com/hisn:186) |

### The first dates of the season

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-187` | <span dir="rtl">اللَّهُمَّ بَارِكْ لَنَا فِي ثَمَرِنَا، وَبَارِكْ لَنَا فِي…</span> | [hisn:187](https://sunnah.com/hisn:187) |

### Sneezing

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-188` | <span dir="rtl">إِذَا عَطَسَ أَحَدُكُم فَلْيَقُلِ الْحَمْدُ لِلَّهِ، وَلْيَ…</span> | [hisn:188](https://sunnah.com/hisn:188) |

### When a non-Muslim praises Allah after sneezing

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-189` | <span dir="rtl">يَهْدِيكُمُ اللَّهُ وَيُصْلِحُ بَالَكُمْ.</span> | [hisn:189](https://sunnah.com/hisn:189) |

### For the groom

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-190` | <span dir="rtl">بَارَكَ اللَّهُ لَكَ، وَبَارَكَ عَلَيْكَ، وَجَمَعَ بَيْنَكُ…</span> | [hisn:190](https://sunnah.com/hisn:190) |

### On the wedding night

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-191` | <span dir="rtl">إِذَا تَزَوَّجَ أَحَدُكُمُ امْرَأَةً، أَوْ إِذَا اشْتَرَى خ…</span> | [hisn:191](https://sunnah.com/hisn:191) |

### Before intimacy

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-192` | <span dir="rtl">بِسْمِ اللَّهِ، اللَّهُمَّ جَنِّبْنَا الشَّيْطَانَ، وَجَنِّ…</span> | [hisn:192](https://sunnah.com/hisn:192) |

### Sitting in a gathering

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-195` | <span dir="rtl">عَنِ ابْنِ عُمَرَ رضي الله عنه قَاَلَ: كَانَ يُعَدُّ لِرَسُ…</span> | [hisn:195](https://sunnah.com/hisn:195) |

### Closing a gathering

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-196` | <span dir="rtl">سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ، أَشْهَدُ أَنْ لاَ إِلَ…</span> | [hisn:15](https://sunnah.com/hisn:15) |

### For someone who says 'may Allah forgive you'

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-197` | <span dir="rtl">وَلَكَ.</span> | [hisn:197](https://sunnah.com/hisn:197) |

### For someone who does you good

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-198` | <span dir="rtl">جَزَاكَ اللَّهُ خَيْراً.</span> | [hisn:198](https://sunnah.com/hisn:198) |

### For someone who loves you for Allah's sake

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-200` | <span dir="rtl">أَحَبَّكَ الَّذِي أَحْبَبْتَنِي لَهُ.</span> | [hisn:200](https://sunnah.com/hisn:200) |

### For someone who shares their wealth

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-201` | <span dir="rtl">بَارَكَ اللَّهُ لَكَ فِي أَهْلِكَ وَمَالِكَ.</span> | [hisn:201](https://sunnah.com/hisn:201) |

### On repaying a loan

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-202` | <span dir="rtl">بارَكَ اللَّهُ لَكَ فِي أَهْلِكَ وَمَالِكَ، إِنَّمَا جَزَاء…</span> | [hisn:202](https://sunnah.com/hisn:202) |

### For someone who says 'may Allah bless you'

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-204` | <span dir="rtl">وَفِيكَ بَارَكَ اللَّهُ.</span> | [hisn:204](https://sunnah.com/hisn:204) |

### Riding

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-206` | <span dir="rtl">بِسْمِ اللَّهِ، وَالْحَمْدُ للَّهِ ﴿سُبْحَانَ الَّذِي سَخَّ…</span> | [hisn:206](https://sunnah.com/hisn:206) |

### Travelling

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-207` | <span dir="rtl">اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، ﴿سُبْ…</span> | [hisn:207](https://sunnah.com/hisn:207) |

### Entering a town

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-208` | <span dir="rtl">اللَّهُمَّ رَبَّ السَّمَوَاتِ السَّبْعِ وَمَا أَظْلَلْنَ، و…</span> | [hisn:208](https://sunnah.com/hisn:208) |

### Entering the market

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-209` | <span dir="rtl">لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ ا…</span> | [hisn:209](https://sunnah.com/hisn:209) |

### When your vehicle breaks down

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-210` | <span dir="rtl">بِسْمِ اللَّهِ.</span> | [hisn:9](https://sunnah.com/hisn:9) |

### Leaving someone behind

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-211` | <span dir="rtl">أَسْتَوْدِعُكُمُ اللَّهَ الَّذِي لاَ تَضِيعُ وَدَائِعُهُ.</span> | [hisn:211](https://sunnah.com/hisn:211) |

### Seeing a traveller off

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-212` | <span dir="rtl">أَسْتَوْدِعُ اللَّهَ دِينَكَ، وَأَمَانَتَكَ، وَخَوَاتِيمَ ع…</span> | [hisn:212](https://sunnah.com/hisn:212) |
| 2 | `hisn-213` | <span dir="rtl">زَوَّدَكَ اللَّهُ التَّقْوَى، وَغَفَرَ ذَنْبَكَ، وَيَسَّرَ…</span> | [hisn:213](https://sunnah.com/hisn:213) |

### Climbing and descending on a journey

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-214` | <span dir="rtl">قَالَ جَابِرٌ رضي الله عنه: كُنَّا إِذَا صَعَدْنَا كَبَّرْن…</span> | [hisn:214](https://sunnah.com/hisn:214) |

### A traveller at dawn

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-215` | <span dir="rtl">سَمَّعَ سَامِعٌ بِحَمْدِ اللَّهِ، وَحُسْنِ بَلاَئِهِ عَلَيْ…</span> | [hisn:215](https://sunnah.com/hisn:215) |

### Stopping along the way

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-216` | <span dir="rtl">أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَل…</span> | [hisn:216](https://sunnah.com/hisn:216) |

### Returning from a journey

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-217` | <span dir="rtl">يُكَبِّرُ عَلَى كُلِّ شَرَفٍ ثَلاَثَ تَكْبِيرَاتٍ ثُمَّ يَق…</span> | [hisn:217](https://sunnah.com/hisn:217) |

### When something pleases or displeases you

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-218` | <span dir="rtl">كَانَ النَّبِيُّ صلى الله عليه وسلم إِذَا أَتَاهُ الْأَمْرُ…</span> | [hisn:218](https://sunnah.com/hisn:218) |

### The excellence of asking blessings on the Prophet ﷺ

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-219` | <span dir="rtl">قَالَ النَّبِيُّ صلى الله عليه وسلم: مَنْ صَلَّى عَلَيَّ صَ…</span> | [hisn:219](https://sunnah.com/hisn:219) |
| 2 | `hisn-220` | <span dir="rtl">وَقَالَ صلى الله عليه وسلم: لاَ تَجْعَلُوا قَبْرِي عِيداً و…</span> | [hisn:220](https://sunnah.com/hisn:220) |
| 3 | `hisn-221` | <span dir="rtl">وَقَالَ صلى الله عليه وسلم: الْبَخِيلُ مَنْ ذُكِرْتُ عِنْدَ…</span> | [hisn:221](https://sunnah.com/hisn:221) |
| 4 | `hisn-222` | <span dir="rtl">وَقَالَ صلى الله عليه وسلم:إِنَّ لِلَّهِ مَلاَئِكَةً سَيَّا…</span> | [hisn:222](https://sunnah.com/hisn:222) |
| 5 | `hisn-223` | <span dir="rtl">وَقَالَ صلى الله عليه وسلم: مَا مِنْ أَحَدٍ يُسَلِّمُ عَلَي…</span> | [hisn:223](https://sunnah.com/hisn:223) |

### Spreading the salam

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-224` | <span dir="rtl">قَالَ رَسُولُ اللَّهِ صلى الله عليه وسلم: لاَ تَدْخُلُوا ال…</span> | [hisn:224](https://sunnah.com/hisn:224) |
| 2 | `hisn-225` | <span dir="rtl">ثَلاَثٌ مَنْ جَمَعَهُنَّ فَقَدْ جَمَعَ الْإِيمَانَ: الْإِنْ…</span> | [hisn:225](https://sunnah.com/hisn:225) |
| 3 | `hisn-226` | <span dir="rtl">وَعَنْ عَبْدِ اللَّهِ بْنِ عُمَرَ رَضِيَ اللَّهُ عَنْهُمَا:…</span> | [hisn:226](https://sunnah.com/hisn:226) |

### Replying to a non-Muslim's greeting

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-227` | <span dir="rtl">إذَا سَلَّمَ عَلَيْكُمْ أَهْلُ الْكِتَابِ فَقُولُوا: وَعَلَ…</span> | [hisn:227](https://sunnah.com/hisn:227) |

### Hearing a rooster or a donkey

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-228` | <span dir="rtl">إِذَا سَمِعْتُمْ صِيَاحَ الدِّيَكَةِ فَاسْأَلُوا اللَّهَ مِ…</span> | [hisn:228](https://sunnah.com/hisn:228) |

### Hearing a dog bark at night

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-229` | <span dir="rtl">إِذَا سَمِعْتُمْ نُبَاحَ الْكِلاَبِ وَنَهِيقَ الْحَمِيرِ بِ…</span> | [hisn:229](https://sunnah.com/hisn:229) |

### Praising another Muslim

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-231` | <span dir="rtl">قَالَ النَّبِيُّ صلى الله عليه وسلم: إِذَا كَانَ أَحَدُكُم…</span> | [hisn:231](https://sunnah.com/hisn:231) |

### When you are praised

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-232` | <span dir="rtl">اللَّهُمَّ لاَ تُؤَاخِذْنِي بِمَا يَقُولُونَ، وَاغْفِرْ لِي…</span> | [hisn:232](https://sunnah.com/hisn:232) |

### The talbiyah

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-233` | <span dir="rtl">لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ، لَبَّيْكَ لاَ شَرِيكَ لَكَ…</span> | [hisn:233](https://sunnah.com/hisn:233) |

### Passing the Black Stone

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-234` | <span dir="rtl">طَافَ النَّبيُّ صلى الله عليه وسلم بِالْبَيْتِ عَلَى بَعِير…</span> | [hisn:234](https://sunnah.com/hisn:234) |

### Between the Yemeni Corner and the Black Stone

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-235` | <span dir="rtl">﴿رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ ح…</span> | [hisn:235](https://sunnah.com/hisn:235) |

### Standing at Safa and Marwah

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-236` | <span dir="rtl">لَمَّا دَنَا النَّبِيُّ صلى الله عليه وسلم مِنَ الصَّفَا قَ…</span> | [hisn:236](https://sunnah.com/hisn:236) |

### The Day of 'Arafah

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-237` | <span dir="rtl">قَالَ النَّبِيُّ صلى الله عليه وسلم: خَيْرُ الدُّعَاءِ دُعَ…</span> | [hisn:237](https://sunnah.com/hisn:237) |

### At Muzdalifah

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-238` | <span dir="rtl">رَكِبَ النَّبِيُّ صلى الله عليه وسلم الْقَصْوَاءَ حَتَّى أَ…</span> | [hisn:238](https://sunnah.com/hisn:238) |

### Stoning the pillars at Mina

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-239` | <span dir="rtl">يُكَبِّرُ كُلَّمَا رَمَى بِحَصَاةٍ عِنْدَ الْجِمَارِ الثَّل…</span> | [hisn:239](https://sunnah.com/hisn:239) |

### When something delights you

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-242` | <span dir="rtl">كَانَ النَّبيُّ صلى الله عليه وسلم إِذَا أَتَاهُ أَمْرٌ يَس…</span> | [hisn:242](https://sunnah.com/hisn:242) |

### Slaughtering

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-246` | <span dir="rtl">بِسْمِ اللَّهِ وَاللَّهُ أَكْبَرُ [اللَّهُمَّ مِنْكَ وَلَكَ…</span> | [hisn:246](https://sunnah.com/hisn:246) |

### Repentance and seeking forgiveness

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-248` | <span dir="rtl">قَالَ رَسُولُ اللَّهِ صلى الله عليه وسلم: وَاللَّهِ إِنِّي…</span> | [hisn:248](https://sunnah.com/hisn:248) |
| 2 | `hisn-249` | <span dir="rtl">وَقَالَ صلى الله عليه وسلم: يَا أَيُّهَا النَّاسُ تُوبُوا إ…</span> | [hisn:249](https://sunnah.com/hisn:249) |
| 3 | `hisn-250` | <span dir="rtl">وَقَالَ صلى الله عليه وسلم: مَنْ قَالَ أَسْتَغْفِرُ اللَّهَ…</span> | [hisn:250](https://sunnah.com/hisn:250) |
| 4 | `hisn-251` | <span dir="rtl">وَقَالَ صلى الله عليه وسلم: أَقْرَبُ مَا يَكُونُ الرَّبُّ م…</span> | [hisn:251](https://sunnah.com/hisn:251) |
| 5 | `hisn-252` | <span dir="rtl">وَقَالَ صلى الله عليه وسلم: أَقْرَبُ مَا يَكُونُ الْعَبْدُ…</span> | [hisn:252](https://sunnah.com/hisn:252) |
| 6 | `hisn-253` | <span dir="rtl">وَقَالَ صلى الله عليه وسلم: إِنَّهُ لَيُغَانُ عَلَى قَلْبِي…</span> | [hisn:253](https://sunnah.com/hisn:253) |

### The excellence of remembering Allah

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-254` | <span dir="rtl">قَالَ صلى الله عليه وسلم مَنْ قَالَ: سُبْحَانَ اللَّهِ وَبِ…</span> | [hisn:254](https://sunnah.com/hisn:254) |
| 2 | `hisn-255` | <span dir="rtl">وَقَالَ صلى الله عليه وسلم: مَنْ قَالَ لاَ إِلَهَ إِلاَّ ال…</span> | [hisn:255](https://sunnah.com/hisn:255) |
| 3 | `hisn-256` | <span dir="rtl">وَقَالَ صلى الله عليه وسلم: كَلِمَتَانِ خَفِيفَتَانِ عَلَى…</span> | [hisn:256](https://sunnah.com/hisn:256) |
| 4 | `hisn-257` | <span dir="rtl">وَقَالَ صلى الله عليه وسلم: لَأَنْ أَقُولَ سُبْحَانَ اللَّه…</span> | [hisn:257](https://sunnah.com/hisn:257) |
| 5 | `hisn-258` | <span dir="rtl">وَقَالَ صلى الله عليه وسلم: أَيَعْجِزُ أَحَدُكُم أَنْ يَكْس…</span> | [hisn:258](https://sunnah.com/hisn:258) |
| 6 | `hisn-259` | <span dir="rtl">مَنْ قَالَ: سُبْحَانَ اللَّهِ الْعَظِيمِ وَبِحَمْدِهِ غُرِس…</span> | [hisn:259](https://sunnah.com/hisn:259) |
| 7 | `hisn-260` | <span dir="rtl">وَقَالَ صلى الله عليه وسلم: يَا عَبْدَ اللَّهِ بْنَ قَيْسٍ…</span> | [hisn:260](https://sunnah.com/hisn:260) |
| 8 | `hisn-261` | <span dir="rtl">وَقَالَ صلى الله عليه وسلم: أَحَبُّ الْكَلاَمِ إِلَى اللَّه…</span> | [hisn:261](https://sunnah.com/hisn:261) |
| 9 | `hisn-262` | <span dir="rtl">جَاءَ أَعْرَابِيٌّ إِلَى رَسُولِ اللَّهِ صلى الله عليه وسلم…</span> | [hisn:262](https://sunnah.com/hisn:262) |
| 10 | `hisn-263` | <span dir="rtl">كَانَ الرَّجُلُ إِذَا أَسْلَمَ عَلَّمَهُ النَّبيُّ صلى الله…</span> | [hisn:263](https://sunnah.com/hisn:263) |
| 11 | `hisn-264` | <span dir="rtl">إِنَّ أَفْضَلَ الدُّعَاءِ الْحَمْدُ لِلَّهِ، وَأَفْضَلَ الذ…</span> | [hisn:264](https://sunnah.com/hisn:264) |
| 12 | `hisn-265` | <span dir="rtl">الباقيات الصالحات : سبحان الله والحمد لله ، ولا إله إلا الل…</span> | [hisn:265](https://sunnah.com/hisn:265) |

### How the Prophet ﷺ glorified Allah

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-266` | <span dir="rtl">عَنْ عَبْدِ اللَّهِ بْنِ عَمْرٍو رضي الله عنه قَالَ: رَأَيْ…</span> | [hisn:266](https://sunnah.com/hisn:266) |

### Goodness and good manners

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-267` | <span dir="rtl">قَالَ النَّبِيُّ صلى الله عليه وسلم إِذَا كَانَ جُنْحُ اللّ…</span> | [hisn:267](https://sunnah.com/hisn:267) |

---

## Prayers of the Prophets

### Adam

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `dua-adam-zalamna-anfusana` | <span dir="rtl">رَبَّنَا ظَلَمۡنَآ أَنفُسَنَا وَإِن لَّمۡ تَغۡفِرۡ لَنَا وَ…</span> | [Qur'an 7:23](https://quran.com/7/23) |

### Nuh

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `dua-nuh-inni-maghlub` | <span dir="rtl">أَنِّي مَغۡلُوبٞ فَٱنتَصِرۡ</span> | [Qur'an 54:10](https://quran.com/54/10) |
| 2 | `dua-nuh-munzalan-mubarakan` | <span dir="rtl">رَّبِّ أَنزِلۡنِي مُنزَلٗا مُّبَارَكٗا وَأَنتَ خَيۡرُ ٱلۡمُ…</span> | [Qur'an 23:29](https://quran.com/23/29) |
| 3 | `dua-nuh-ighfir-li-wa-liwalidayya` | <span dir="rtl">رَّبِّ ٱغۡفِرۡ لِي وَلِوَٰلِدَيَّ وَلِمَن دَخَلَ بَيۡتِيَ م…</span> | [Qur'an 71:28](https://quran.com/71/28) |

### Ibrahim

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `dua-ibrahim-rabbi-hab-li-hukman` | <span dir="rtl">رَبِّ هَبۡ لِي حُكۡمٗا وَأَلۡحِقۡنِي بِٱلصَّـٰلِحِينَ وَٱجۡ…</span> | [Qur'an 26:83-87](https://quran.com/26/83-87) |
| 2 | `dua-ibrahim-taqabbal-minna` | <span dir="rtl">رَبَّنَا تَقَبَّلۡ مِنَّآۖ إِنَّكَ أَنتَ ٱلسَّمِيعُ ٱلۡعَلِ…</span> | [Qur'an 2:127-129](https://quran.com/2/127-129) |
| 3 | `dua-ibrahim-baladan-aminan` | <span dir="rtl">رَبِّ ٱجۡعَلۡ هَٰذَا ٱلۡبَلَدَ ءَامِنٗا وَٱجۡنُبۡنِي وَبَنِ…</span> | [Qur'an 14:35-37](https://quran.com/14/35-37) |
| 4 | `dua-ibrahim-muqim-as-salah` | <span dir="rtl">رَبِّ ٱجۡعَلۡنِي مُقِيمَ ٱلصَّلَوٰةِ وَمِن ذُرِّيَّتِيۚ رَب…</span> | [Qur'an 14:40-41](https://quran.com/14/40-41) |

### Lut and Shu'ayb

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `dua-lut-najjini-wa-ahli` | <span dir="rtl">رَبِّ نَجِّنِي وَأَهۡلِي مِمَّا يَعۡمَلُونَ</span> | [Qur'an 26:169](https://quran.com/26/169) |
| 2 | `dua-lut-unsurni` | <span dir="rtl">رَبِّ ٱنصُرۡنِي عَلَى ٱلۡقَوۡمِ ٱلۡمُفۡسِدِينَ</span> | [Qur'an 29:30](https://quran.com/29/30) |
| 3 | `dua-shuayb-iftah-baynana` | <span dir="rtl">رَبَّنَا ٱفۡتَحۡ بَيۡنَنَا وَبَيۡنَ قَوۡمِنَا بِٱلۡحَقِّ وَ…</span> | [Qur'an 7:89](https://quran.com/7/89) |

### Yusuf and Ya'qub

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `dua-yusuf-as-sijnu-ahabbu` | <span dir="rtl">رَبِّ ٱلسِّجۡنُ أَحَبُّ إِلَيَّ مِمَّا يَدۡعُونَنِيٓ إِلَيۡ…</span> | [Qur'an 12:33](https://quran.com/12/33) |
| 2 | `dua-yusuf-tawaffani-musliman` | <span dir="rtl">رَبِّ قَدۡ ءَاتَيۡتَنِي مِنَ ٱلۡمُلۡكِ وَعَلَّمۡتَنِي مِن ت…</span> | [Qur'an 12:101](https://quran.com/12/101) |
| 3 | `dua-yaqub-ashku-bathi` | <span dir="rtl">إِنَّمَآ أَشۡكُواْ بَثِّي وَحُزۡنِيٓ إِلَى ٱللَّهِ وَأَعۡلَ…</span> | [Qur'an 12:86](https://quran.com/12/86) |

### Musa

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `dua-musa-zalamtu-nafsi` | <span dir="rtl">رَبِّ إِنِّي ظَلَمۡتُ نَفۡسِي فَٱغۡفِرۡ لِي</span> | [Qur'an 28:16](https://quran.com/28/16) |
| 2 | `dua-musa-faqir` | <span dir="rtl">رَبِّ إِنِّي لِمَآ أَنزَلۡتَ إِلَيَّ مِنۡ خَيۡرٖ فَقِيرٞ</span> | [Qur'an 28:24](https://quran.com/28/24) |
| 3 | `dua-musa-ishrah-li-sadri` | <span dir="rtl">رَبِّ ٱشۡرَحۡ لِي صَدۡرِي وَيَسِّرۡ لِيٓ أَمۡرِي وَٱحۡلُلۡ…</span> | [Qur'an 20:25-28](https://quran.com/20/25-28) |
| 4 | `dua-musa-ighfir-li-wa-liakhi` | <span dir="rtl">رَبِّ ٱغۡفِرۡ لِي وَلِأَخِي وَأَدۡخِلۡنَا فِي رَحۡمَتِكَۖ و…</span> | [Qur'an 7:151](https://quran.com/7/151) |

### Ayyub and Yunus

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `dua-ayyub-massaniya-ad-durr` | <span dir="rtl">أَنِّي مَسَّنِيَ ٱلضُّرُّ وَأَنتَ أَرۡحَمُ ٱلرَّـٰحِمِينَ</span> | [Qur'an 21:83](https://quran.com/21/83) |
| 2 | `dua-yunus-la-ilaha-illa-anta` | <span dir="rtl">لَّآ إِلَٰهَ إِلَّآ أَنتَ سُبۡحَٰنَكَ إِنِّي كُنتُ مِنَ ٱلظ…</span> | [Qur'an 21:87](https://quran.com/21/87) |

### Dawud and Sulayman

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `dua-sulayman-awzini-an-ashkura` | <span dir="rtl">رَبِّ أَوۡزِعۡنِيٓ أَنۡ أَشۡكُرَ نِعۡمَتَكَ ٱلَّتِيٓ أَنۡعَ…</span> | [Qur'an 27:19](https://quran.com/27/19) |
| 2 | `dua-sulayman-mulkan` | <span dir="rtl">رَبِّ ٱغۡفِرۡ لِي وَهَبۡ لِي مُلۡكٗا لَّا يَنۢبَغِي لِأَحَد…</span> | [Qur'an 38:35](https://quran.com/38/35) |

### Zakariyya and 'Isa

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `dua-zakariyya-dhurriyyatan-tayyibah` | <span dir="rtl">رَبِّ هَبۡ لِي مِن لَّدُنكَ ذُرِّيَّةٗ طَيِّبَةًۖ إِنَّكَ س…</span> | [Qur'an 3:38](https://quran.com/3/38) |
| 2 | `dua-zakariyya-la-tadharni-fardan` | <span dir="rtl">رَبِّ لَا تَذَرۡنِي فَرۡدٗا وَأَنتَ خَيۡرُ ٱلۡوَٰرِثِينَ</span> | [Qur'an 21:89](https://quran.com/21/89) |
| 3 | `dua-isa-anzil-alayna-maidah` | <span dir="rtl">ٱللَّهُمَّ رَبَّنَآ أَنزِلۡ عَلَيۡنَا مَآئِدَةٗ مِّنَ ٱلسَّ…</span> | [Qur'an 5:114](https://quran.com/5/114) |

### Muhammad ﷺ, in the Qur'an

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `dua-nabi-rabbi-zidni-ilman` | <span dir="rtl">رَّبِّ زِدۡنِي عِلۡمٗا</span> | [Qur'an 20:114](https://quran.com/20/114) |
| 2 | `dua-nabi-mudkhala-sidqin` | <span dir="rtl">رَّبِّ أَدۡخِلۡنِي مُدۡخَلَ صِدۡقٖ وَأَخۡرِجۡنِي مُخۡرَجَ ص…</span> | [Qur'an 17:80](https://quran.com/17/80) |
| 3 | `dua-nabi-rabbi-ighfir-warham` | <span dir="rtl">رَّبِّ ٱغۡفِرۡ وَٱرۡحَمۡ وَأَنتَ خَيۡرُ ٱلرَّـٰحِمِينَ</span> | [Qur'an 23:118](https://quran.com/23/118) |

### The prayers the Qur'an teaches

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `dua-rabbana-atina-fid-dunya` | <span dir="rtl">رَبَّنَآ ءَاتِنَا فِي ٱلدُّنۡيَا حَسَنَةٗ وَفِي ٱلۡأٓخِرَةِ…</span> | [Qur'an 2:201](https://quran.com/2/201) |
| 2 | `dua-rabbana-la-tuakhidhna` | <span dir="rtl">رَبَّنَا لَا تُؤَاخِذۡنَآ إِن نَّسِينَآ أَوۡ أَخۡطَأۡنَاۚ ر…</span> | [Qur'an 2:286](https://quran.com/2/286) |
| 3 | `dua-rabbana-la-tuzigh-qulubana` | <span dir="rtl">رَبَّنَا لَا تُزِغۡ قُلُوبَنَا بَعۡدَ إِذۡ هَدَيۡتَنَا وَهَ…</span> | [Qur'an 3:8-9](https://quran.com/3/8-9) |
| 4 | `dua-rabbana-innana-amanna` | <span dir="rtl">رَبَّنَآ إِنَّنَآ ءَامَنَّا فَٱغۡفِرۡ لَنَا ذُنُوبَنَا وَقِ…</span> | [Qur'an 3:16-17](https://quran.com/3/16-17) |
| 5 | `dua-rabbana-ma-khalaqta-hadha-batilan` | <span dir="rtl">رَبَّنَا مَا خَلَقۡتَ هَٰذَا بَٰطِلٗا سُبۡحَٰنَكَ فَقِنَا ع…</span> | [Qur'an 3:191-194](https://quran.com/3/191-194) |
| 6 | `dua-rabbana-hab-lana-qurrata-ayun` | <span dir="rtl">رَبَّنَا هَبۡ لَنَا مِنۡ أَزۡوَٰجِنَا وَذُرِّيَّـٰتِنَا قُر…</span> | [Qur'an 25:74](https://quran.com/25/74) |
| 7 | `dua-rabbana-atmim-lana-nurana` | <span dir="rtl">رَبَّنَآ أَتۡمِمۡ لَنَا نُورَنَا وَٱغۡفِرۡ لَنَآۖ إِنَّكَ ع…</span> | [Qur'an 66:8](https://quran.com/66/8) |
| 8 | `dua-rabbana-ighfir-lana-wa-liikhwanina` | <span dir="rtl">رَبَّنَا ٱغۡفِرۡ لَنَا وَلِإِخۡوَٰنِنَا ٱلَّذِينَ سَبَقُونَ…</span> | [Qur'an 59:10](https://quran.com/59/10) |

---

## Prayers from the Seerah

### The years in Makkah

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `dua-seerah-ighfir-li-qawmi` | <span dir="rtl">اللَّهُمَّ اغْفِرْ لِقَوْمِي فَإِنَّهُمْ لاَ يَعْلَمُونَ</span> | [bukhari:3477](https://sunnah.com/bukhari:3477) |
| 2 | `dua-seerah-aizz-al-islam` | <span dir="rtl">اللَّهُمَّ أَعِزَّ الإِسْلاَمَ بِأَحَبِّ هَذَيْنِ الرَّجُلَ…</span> | [tirmidhi:3681](https://sunnah.com/tirmidhi:3681) |
| 3 | `dua-seerah-ya-muqallib` | <span dir="rtl">يَا مُقَلِّبَ الْقُلُوبِ ثَبِّتْ قَلْبِي عَلَى دِينِكَ</span> | [urn:8437155](https://sunnah.com/urn/8437155) |

### Badr

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `dua-seerah-badr` | <span dir="rtl">اللَّهُمَّ أَنْجِزْ لِي مَا وَعَدْتَنِي اللَّهُمَّ آتِ مَا…</span> | [urn:7545020](https://sunnah.com/urn/7545020) |

### Madinah

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `dua-seerah-madinah` | <span dir="rtl">اللَّهُمَّ حَبِّبْ إِلَيْنَا الْمَدِينَةَ كَحُبِّنَا مَكَّة…</span> | **NOT FOUND** (Sahih al-Bukhari 1889 (no. 1821), narrated by 'A'ishah.) |

### The day his son died

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `dua-seerah-ibrahim` | <span dir="rtl">إِنَّ الْعَيْنَ تَدْمَعُ، وَالْقَلْبَ يَحْزَنُ، وَلاَ نَقُو…</span> | [mishkat:1722](https://sunnah.com/mishkat:1722) |

---

## Prayers of the Companions

### Taught to one of them

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `dua-abu-bakr-fi-salati` | <span dir="rtl">اللَّهُمَّ إِنِّي ظَلَمْتُ نَفْسِي ظُلْمًا كَثِيرًا وَلاَ ي…</span> | [hisn:57](https://sunnah.com/hisn:57) |
| 2 | `dua-aishah-laylat-al-qadr` | <span dir="rtl">اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي</span> | **NOT FOUND** (Sunan Ibn Majah 3850 (no. 3586); also Jami' at-Tirmidhi 3513. Narrated by 'A'ishah. Graded sahih by al-Albani.) |
| 3 | `dua-muadh-ainni` | <span dir="rtl">اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَ…</span> | [hisn:59](https://sunnah.com/hisn:59) |
| 4 | `dua-ali-ihdini` | <span dir="rtl">اللَّهُمَّ اهْدِنِي وَسَدِّدْنِي</span> | **NOT FOUND** (Sunan an-Nasa'i 5221; also Sahih Muslim 2725 and Sunan Abi Dawud 4226. Narrated by 'Ali ibn Abi Talib.) |
| 5 | `dua-ibn-masud-al-huda` | <span dir="rtl">اللَّهُمَّ إِنِّي أَسْأَلُكَ الْهُدَى وَالتُّقَى وَالْعَفَا…</span> | **NOT FOUND** (Jami' at-Tirmidhi 3489 (no. 3573); also Sahih Muslim 2721. Narrated by 'Abdullah ibn Mas'ud. Graded hasan sahih by at-Tirmidhi.) |

### Prayers he made for them

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `dua-anas-akthir-malahu` | <span dir="rtl">اللَّهُمَّ أَكْثِرْ مَالَهُ وَوَلَدَهُ وَبَارِكْ لَهُ فِيمَ…</span> | **NOT FOUND** (Jami' at-Tirmidhi 3833 (no. 3926); also Sahih Muslim 2480 and 660. Narrated by Anas ibn Malik from Umm Sulaym. Graded hasan sahih by at-Tir…) |
| 2 | `dua-ibn-abbas-faqqihhu` | <span dir="rtl">اللَّهُمَّ فَقِّهْهُ فِي الدِّينِ</span> | **NOT FOUND** (Sahih al-Bukhari 143, narrated by Ibn 'Abbas.) |

### Said by one of them

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `dua-umar-istisqa` | <span dir="rtl">اللَّهُمَّ إِنَّا كُنَّا نَتَوَسَّلُ إِلَيْكَ بِنَبِيِّنَا…</span> | **NOT FOUND** (Sahih al-Bukhari 1010 (no. 982), narrated by Anas ibn Malik.) |

---

## When You Need It

### Worry and grief

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-120` | <span dir="rtl">اللَّهُمَّ إِنِّي عَبْدُكَ، ابْنُ عَبْدِكَ، ابْنُ أَمَتِكَ،…</span> | [hisn:120](https://sunnah.com/hisn:120) |
| 2 | `hisn-121` | <span dir="rtl">اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، و…</span> | [hisn:121](https://sunnah.com/hisn:121) |

### Distress

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-122` | <span dir="rtl">لاَ إِلَهَ إِلاَّ اللَّهُ الْعَظِيمُ الْحَلِيمُ، لاَ إِلَهَ…</span> | [hisn:122](https://sunnah.com/hisn:122) |
| 2 | `hisn-123` | <span dir="rtl">اللَّهُمَّ رَحْمَتَكَ أَرْجُو، فَلاَ تَكِلْنِي إِلَى نَفْسِ…</span> | [hisn:123](https://sunnah.com/hisn:123) |
| 3 | `hisn-124` | <span dir="rtl">لاَ إِلَهَ إِلاَّ أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظ…</span> | [hisn:124](https://sunnah.com/hisn:124) |
| 4 | `hisn-125` | <span dir="rtl">اللَّهُ اللَّهُ رَبِّي لاَ أُشْرِكُ بِهِ شَيْئاً.</span> | [hisn:125](https://sunnah.com/hisn:125) |

### When startled

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-240` | <span dir="rtl">سُبْحَانَ اللَّهِ!.</span> | [hisn:240](https://sunnah.com/hisn:240) |
| 2 | `hisn-241` | <span dir="rtl">اللَّهُ أَكْبَرُ!.</span> | [hisn:241](https://sunnah.com/hisn:241) |

### When you are frightened

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-245` | <span dir="rtl">لاَ إِلَهَ إِلاَّ اللَّهُ!.</span> | [hisn:245](https://sunnah.com/hisn:245) |

### Fearing harm from people

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-132` | <span dir="rtl">اللَّهُمَّ اكْفِنِيهِمْ بِمَا شِئْتَ.</span> | [hisn:132](https://sunnah.com/hisn:132) |

### Against an enemy

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-131` | <span dir="rtl">اللَّهُمَّ مُنْزِلَ الْكِتَابِ، سَرِيعَ الْحِسَابِ، اهْزِمِ…</span> | [hisn:131](https://sunnah.com/hisn:131) |

### Anger

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-193` | <span dir="rtl">أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ.</span> | [hisn:193](https://sunnah.com/hisn:193) |

### Debt

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-136` | <span dir="rtl">اللَّهُمَّ اكْفِنِي بِحَلاَلِكَ عَنْ حَرَامِكَ، وَأَغْنِنِي…</span> | [hisn:136](https://sunnah.com/hisn:136) |
| 2 | `hisn-137` | <span dir="rtl">اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، و…</span> | [hisn:121](https://sunnah.com/hisn:121) |

### When something becomes difficult

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-139` | <span dir="rtl">اللَّهُمَّ لاَ سَهْلَ إِلاَّ مَا جَعَلْتَهُ سَهْلاً، وَأَنْ…</span> | [hisn:139](https://sunnah.com/hisn:139) |

### When something goes wrong

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-144` | <span dir="rtl">قَدَرُ اللَّهُ وَمَا شَاءَ فَعَلَ.</span> | [hisn:144](https://sunnah.com/hisn:144) |

### After committing a sin

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-140` | <span dir="rtl">مَا مِنْ عَبْدٍ يُذنِبُ ذَنْباً فَيُحْسِنُ الطُّهُورَ، ثُمّ…</span> | [hisn:140](https://sunnah.com/hisn:140) |

### Against the devil's promptings

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-141` | <span dir="rtl">الْاسْتِعَاذَةُ بِاللَّهِ مِنْهُ.</span> | [hisn:141](https://sunnah.com/hisn:141) |
| 2 | `hisn-142` | <span dir="rtl">الْأَذَانُ.</span> | [hisn:142](https://sunnah.com/hisn:142) |
| 3 | `hisn-143` | <span dir="rtl">الْأَذْكَارُ وَقِرَاءَةُ الْقُرْآنِ.</span> | [hisn:143](https://sunnah.com/hisn:143) |

### Whispering during prayer and recitation

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-138` | <span dir="rtl">أَعُوذُ بِاللَّهِ مِنَ الشَّيطَانِ الرَّجِيمِ، وَاتْفُلْ عَ…</span> | [hisn:138](https://sunnah.com/hisn:138) |

### Doubt in faith

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-133` | <span dir="rtl">يَسْتَعِيذُ بِاللَّهِ و يَنْتَهِي عَمَّا شك فِيهِ.</span> | [hisn:133](https://sunnah.com/hisn:133) |
| 2 | `hisn-134` | <span dir="rtl">يَقُولُ: آمَنْتُ بِاللَّهِ وَرُسُلِهِ.</span> | [hisn:134](https://sunnah.com/hisn:134) |
| 3 | `hisn-135` | <span dir="rtl">يَقْرَأُ قَوْلَهُ تَعَالَى: ﴿هُوَ الْأوَّلُ وَالْآخِرُ وَال…</span> | [hisn:135](https://sunnah.com/hisn:135) |

### Fear of shirk

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-203` | <span dir="rtl">اللَّهُمَّ إِنِّي أَعُوذُ بِكَ أَنْ أُشْرِكَ بِكَ وَأَنَا أ…</span> | [hisn:203](https://sunnah.com/hisn:203) |

### Against bad omens

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-205` | <span dir="rtl">اللَّهُمَّ لاَ طَيْرَ إِلاَّ طَيْرُكَ، وَلاَ خَيْرَ إِلاَّ…</span> | [hisn:205](https://sunnah.com/hisn:205) |

### When you feel pain

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-243` | <span dir="rtl">ضَعْ يَدَكَ عَلَى الَّذِي تَألَّمَ مِنْ جَسَدِكَ وَقُلْ: بِ…</span> | [hisn:243](https://sunnah.com/hisn:243) |

### Fearing you may give the evil eye

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-244` | <span dir="rtl">إِذَا رَأَى أَحَدُكُم مِنْ أَخِيهِ، أَوْ مِنْ نَفْسِهِ، أَو…</span> | [hisn:244](https://sunnah.com/hisn:244) |

### Seeing someone afflicted

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-194` | <span dir="rtl">الْحَمْدُ لِلَّهِ الَّذِي عَافَانِي مِمَّا ابْتَلاَكَ بِهِ،…</span> | [hisn:194](https://sunnah.com/hisn:194) |

### After speaking ill of someone

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-230` | <span dir="rtl">قَالَ النَّبِيُّ صلى الله عليه وسلم: اللَّهُمَّ فَأَيُّمَا…</span> | [hisn:230](https://sunnah.com/hisn:230) |

### Protection from the Dajjal

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-199` | <span dir="rtl">مَنْ حَفِظَ عَشْرَ آيَاتٍ مِنْ أَوَّلِ سُورَةِ الْكَهْفِ عُ…</span> | [hisn:199](https://sunnah.com/hisn:199) |

### Foiling the devil's plots

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-247` | <span dir="rtl">أَعُوذُ بكَلِمَاتِ اللَّهِ التَّامَّاتِ الَّتِي لاَ يُجَاوِ…</span> | [hisn:247](https://sunnah.com/hisn:247) |

### Istikharah — asking for guidance

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-74` | <span dir="rtl">قَالَ جَابرُ بْنُ عَبْدِ اللَّهِ رَضِيَ اللَّهُ عَنْهُمَا:…</span> | [hisn:74](https://sunnah.com/hisn:74) |

### Facing an adversary or a ruler

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-126` | <span dir="rtl">اللَّهُمَّ إِنَّا نَجْعَلُكَ فِي نُحُورِهِم، وَنَعُوذُ بِكَ…</span> | [hisn:126](https://sunnah.com/hisn:126) |
| 2 | `hisn-127` | <span dir="rtl">اللَّهُمَّ أَنْتَ عَضُدِي، وَأَنْتَ نَصِيرِي، بِكَ أَحُولُ…</span> | [hisn:127](https://sunnah.com/hisn:127) |
| 3 | `hisn-128` | <span dir="rtl">حَسْبُنا اللَّهُ وَنِعْمَ الْوَكِيلُ.</span> | [hisn:128](https://sunnah.com/hisn:128) |

### Against an unjust ruler

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-129` | <span dir="rtl">اللَّهُمَّ ربَّ السَّمَوَاتِ السَّبْعِ، وَرَبَّ الْعَرْشِ ا…</span> | [hisn:129](https://sunnah.com/hisn:129) |
| 2 | `hisn-130` | <span dir="rtl">اللَّهُ أَكْبَرُ، اللَّهُ أَعَزُّ مِنْ خَلْقِهِ جَمِيعاً، ا…</span> | [hisn:130](https://sunnah.com/hisn:130) |

### Visiting the sick

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-147` | <span dir="rtl">لاَ بأْسَ طَهُورٌ إِنْ شَاءَ اللَّهُ.</span> | [hisn:147](https://sunnah.com/hisn:147) |
| 2 | `hisn-148` | <span dir="rtl">أَسْأَلُ اللَّهَ الْعَظيمَ رَبَّ الْعَرْشِ الْعَظِيمِ أَنْ…</span> | [hisn:148](https://sunnah.com/hisn:148) |

### The reward for visiting the sick

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-149` | <span dir="rtl">قَالَ النَّبِيُّ صلى الله عليه وسلم: إِذَا عَادَ الرَّجُلُ…</span> | [hisn:149](https://sunnah.com/hisn:149) |

### For someone near the end

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-150` | <span dir="rtl">اللَّهُمَّ اغْفِرْ لِي، وَارْحَمْنِي، وَأَلْحِقْنِي بِالرَّ…</span> | [hisn:150](https://sunnah.com/hisn:150) |
| 2 | `hisn-151` | <span dir="rtl">جَعَلَ النَّبِيُّ صلى الله عليه وسلم عِنْدَ مَوْتِهِ يُدْخِ…</span> | [hisn:151](https://sunnah.com/hisn:151) |
| 3 | `hisn-152` | <span dir="rtl">لاَ إِلَهَ إِلاَّ اللَّهُ وَاللَّهُ أَكْبَرُ، لاَ إِلَهَ إِ…</span> | [hisn:152](https://sunnah.com/hisn:152) |

### Prompting the dying

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-153` | <span dir="rtl">مَنْ كَانَ آخِرُ كَلاَمِهِ لاَ إِلَهَ إِلاَّ اللَّهُ دَخَلَ…</span> | [hisn:153](https://sunnah.com/hisn:153) |

### When tragedy strikes

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-154` | <span dir="rtl">إِنَّا لِلَّهِ وَإِنَّا إِلَيْهِ رَاجِعُونَ، اللَّهُمَّ أْج…</span> | [hisn:154](https://sunnah.com/hisn:154) |

### Closing the eyes of the dead

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-155` | <span dir="rtl">اللَّهُمَّ اغْفِرْ لِفُلاَنٍ (بِاسْمِهِ) وَارْفَعْ دَرَجَتَ…</span> | [hisn:155](https://sunnah.com/hisn:155) |

### The funeral prayer

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-156` | <span dir="rtl">اللَّهُمَّ اغْفِرْ لَهُ وَارْحَمْهُ، وَعَافِهِ، وَاعْفُ عَن…</span> | [hisn:156](https://sunnah.com/hisn:156) |
| 2 | `hisn-157` | <span dir="rtl">اللَّهُمَّ اغْفِرْ لِحَيِّنَا وَمَيِّتِنَا، وَشَاهِدِنَا وَ…</span> | [hisn:157](https://sunnah.com/hisn:157) |
| 3 | `hisn-158` | <span dir="rtl">اللَّهُمَّ إِنَّ فُلاَنَ بْنَ فُلاَنٍ فِي ذِمَّتِكَ، وَحَبْ…</span> | [hisn:158](https://sunnah.com/hisn:158) |
| 4 | `hisn-159` | <span dir="rtl">اللَّهُمَّ عَبْدُكَ وَابْنُ أَمَتِكَ احْتَاجَ إِلَى رَحْمَت…</span> | [hisn:159](https://sunnah.com/hisn:159) |

### The funeral prayer for a child

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-160` | <span dir="rtl">اللَّهُمَّ أَعِذْهُ مِنْ عَذَابِ القَبْرِ وإن قال: اللَّهُم…</span> | [hisn:160](https://sunnah.com/hisn:160) |
| 2 | `hisn-161` | <span dir="rtl">اللَّهُمَّ اجْعَلْهُ لَنَا فَرَطاً، وَسَلَفاً، وَأَجْراً.</span> | [hisn:161](https://sunnah.com/hisn:161) |

### Condolence

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-162` | <span dir="rtl">إِنَّ للَّهِ مَا أَخَذَ، وَلَهُ مَا أَعْطَى، وَكُلُّ شَيْءٍ…</span> | [hisn:162](https://sunnah.com/hisn:162) |

### Placing the dead in the grave

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-163` | <span dir="rtl">بِسْمِ اللَّهِ وَعَلَى سُنَّةِ رَسُولِ اللَّهِ.</span> | [hisn:163](https://sunnah.com/hisn:163) |

### After the burial

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-164` | <span dir="rtl">اللَّهُمَّ اغْفِرْ لَهُ، اللَّهُمَّ ثَبِّتْهُ.</span> | [hisn:164](https://sunnah.com/hisn:164) |

### Visiting the graves

| # | Slug | Arabic (snip) | Reference |
|---:|---|---|---|
| 1 | `hisn-165` | <span dir="rtl">السَّلاَمُ عَلَيْكُمْ أَهْلَ الدِّيَارِ، مِنَ الْمُؤْمِنِين…</span> | [hisn:165](https://sunnah.com/hisn:165) |

---

## To find later

7 dhikr(s) still need a URL. Full Arabic is included so you can paste it into sunnah.com's search. Send URLs back and add them to the `OVERRIDES` map at the top of `build_hisn_urls.py`, then rerun this script.

| Collection | Chapter | Slug | Arabic | Reference |
|---|---|---|---|---|
| Prayers from the Seerah | Madinah | `dua-seerah-madinah` | <span dir="rtl">اللَّهُمَّ حَبِّبْ إِلَيْنَا الْمَدِينَةَ كَحُبِّنَا مَكَّةَ أَوْ أَشَدَّ، اللَّهُمَّ بَارِكْ لَنَا فِي صَاعِنَا، وَفِي مُدِّنَا، وَصَحِّحْهَا لَنَا وَانْقُلْ حُمَّاهَا إِلَى الْجُحْفَةِ</span> | Sahih al-Bukhari 1889 (no. 1821), narrated by 'A'ishah. |
| Prayers of the Companions | Taught to one of them | `dua-aishah-laylat-al-qadr` | <span dir="rtl">اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي</span> | Sunan Ibn Majah 3850 (no. 3586); also Jami' at-Tirmidhi 3513. Narrated by 'A'ishah. Graded sahih by al-Albani. |
| Prayers of the Companions | Taught to one of them | `dua-ali-ihdini` | <span dir="rtl">اللَّهُمَّ اهْدِنِي وَسَدِّدْنِي</span> | Sunan an-Nasa'i 5221; also Sahih Muslim 2725 and Sunan Abi Dawud 4226. Narrated by 'Ali ibn Abi Talib. |
| Prayers of the Companions | Taught to one of them | `dua-ibn-masud-al-huda` | <span dir="rtl">اللَّهُمَّ إِنِّي أَسْأَلُكَ الْهُدَى وَالتُّقَى وَالْعَفَافَ وَالْغِنَى</span> | Jami' at-Tirmidhi 3489 (no. 3573); also Sahih Muslim 2721. Narrated by 'Abdullah ibn Mas'ud. Graded hasan sahih by at-Tirmidhi. |
| Prayers of the Companions | Prayers he made for them | `dua-anas-akthir-malahu` | <span dir="rtl">اللَّهُمَّ أَكْثِرْ مَالَهُ وَوَلَدَهُ وَبَارِكْ لَهُ فِيمَا أَعْطَيْتَهُ</span> | Jami' at-Tirmidhi 3833 (no. 3926); also Sahih Muslim 2480 and 660. Narrated by Anas ibn Malik from Umm Sulaym. Graded hasan sahih by at-Tir… |
| Prayers of the Companions | Prayers he made for them | `dua-ibn-abbas-faqqihhu` | <span dir="rtl">اللَّهُمَّ فَقِّهْهُ فِي الدِّينِ</span> | Sahih al-Bukhari 143, narrated by Ibn 'Abbas. |
| Prayers of the Companions | Said by one of them | `dua-umar-istisqa` | <span dir="rtl">اللَّهُمَّ إِنَّا كُنَّا نَتَوَسَّلُ إِلَيْكَ بِنَبِيِّنَا فَتَسْقِينَا وَإِنَّا نَتَوَسَّلُ إِلَيْكَ بِعَمِّ نَبِيِّنَا فَاسْقِنَا</span> | Sahih al-Bukhari 1010 (no. 982), narrated by Anas ibn Malik. |

## Coverage

| Collection | Matched | Total | % |
|---|---:|---:|---:|
| Morning & Evening | 50 | 50 | 100% |
| In the Prayer | 56 | 56 | 100% |
| Through the Day | 130 | 130 | 100% |
| Prayers of the Prophets | 36 | 36 | 100% |
| Prayers from the Seerah | 5 | 6 | 83% |
| Prayers of the Companions | 2 | 8 | 25% |
| When You Need It | 57 | 57 | 100% |
| **All** | **336** | **343** | **98%** |

Of the 336 matched: 291 to `sunnah.com/hisn:N`, 36 to `quran.com/S/A`, 9 from the manual `OVERRIDES` map.
