# Quality Assurance in OCR-D

## Rationale

Estimating the quality of OCR requires workflows run on representative data,
evaluation metrics and evaluation tools that need to work together in a
well-defined manner to allow users to make informed decisions about which OCR
solution works best for their use case.

## Evaluation Metrics

The evaluation of the success (accuracy) of OCR is a complex task for which multiple methods and metrics are available. It aims to capture quality in different aspects, such as the recognition of text, but also the detection of layout, for which different methods and metrics are needed.

Furthermore, the time and resources required for OCR processing also have to be captured. Here we describe the metrics that were selected for use in OCR-D, how exactly they are applied, and what was the motivation.

### Scope of These Definitions

At this stage (Q3 2022) these definitions serve as a basis of common understanding for the metrics used in the benchmarking presented in OCR-D QUIVER. Further implications for evaluation tools do not yet apply.

### Text Evaluation

The most important measure to assess the quality of OCR is the accuracy of the recognized text. The majority of metrics for this are based on the Levenshtein distance, an algorithm to compute the distance between two strings. In OCR, one of these strings is generally the Ground Truth text and the other the recognized text which is the result of an OCR.

#### Levenshtein Distance (Edit Distance)

Levenshtein distance between two strings `a` and `b` is the number of edit operations needed to turn `a` into `b`. Edit operations depend on the specific variant of the algorithm but for OCR, relevant operations are deletion, insertion and substitution.

The Levenshtein distance forms the basis for the calculation of [CER/WER](https://pad.gwdg.de/#CERWER).
As there are different implementations of the edit distance available (e.g. [rapidfuzz](https://maxbachmann.github.io/RapidFuzz/Usage/distance/Levenshtein.html), [jellyfish](https://jamesturk.github.io/jellyfish/functions/#levenshtein-distance), …), the OCR-D coordination project will provide a recommendation in the final version of this document.

##### Example

Given a Ground truth that reads `ſind` and the recognized text `fmd`.

The Levenshtein distance between these texts is 4, because 4 edit operations are necessary to turn `fmd` into `ſind`:

* `fmd` --> `ſmd` (substitution)
* `ſmd` --> `ſimd` (insertion)
* `ſimd` --> `ſind` (substitution)

#### CER and WER

##### Characters

A text consists of a set of characters that have a certain meaning. A character is a glyph that represents a word, a letter in a word, or a symbol.
Not included in the character definition are all forms of white spaces.

###### Examples

* the character `a` in the text `babst` represents the German letter `a`
* the character `&` represents the Latin abbreviation `etc.`
* the character `☿` represents an Astronomical symbol for the planet Mercury

##### Character Error Rate (CER)

The character error rate (CER) describes how many faulty characters the output of an OCR engine contains compaired to the Ground Truth text in relation to the text length (i.e. the number of characters of the text in the GT)

Errors fall into one of the following three categories:

* **deletion**: a character that is present in the text has been deleted from the output.

Example:
![A Fraktur sample reading "Sonnenfinſterniſſe:"](https://pad.gwdg.de/uploads/d7fa6f23-7c79-4fb2-ad94-7e98084c69d6.jpg)

This reads `Sonnenfinſterniſſe:`. The output contains `Sonnenfinſterniſſe`, deleting `:`.

* **substitution**: a character is replaced by another character in the output.

Example:

![A Fraktur sample reading "Die Finſterniſſe des 1801ſten Jahrs"](https://pad.gwdg.de/uploads/b894049b-8d98-4fe7-ac31-71b2c9393a6c.jpg)

This heading reads `Die Finſterniſſe des 1801ſten Jahrs`. The output contains `180iſten`, replacing `1` with `i`.

* **insertion**: a new character is introduced in the output.

Example:

![A Fraktur sample reading "diese Strahlen, und"](https://pad.gwdg.de/uploads/e6b6432e-d79c-4568-9aef-15a026c05b39.jpg)

This reads `diese Strahlen, und`. The output contains `Strahlen ,`, inserting a white space before the comma.

CER can be calculated in several ways, depending on whether a normalized CER is used or not.

Given $i$ as the number of insertions, $d$ the number of deletions, $s$ the number of substitutions and $n$ the total number of characters in a text, the CER can be obtained by

$CER = \frac{i + s+ d}{n}$

If the CER value is calculated this way, it represents the percentage of characters incorrectly recognized by the OCR engine. Also, we can easily reach error rates beyond 100% when the output contains a lot of insertions.

The *normalized* CER tries to mitigate this effect by considering the number of correct characters, $c$:

$CER_n = \frac{i + s+ d}{i + s + d + c}$

In OCR-D's benchmarking we calculate the *non-normalized* CER where values over 1 should be read as 100%.

###### CER Granularity

In OCR-D we distinguish between the CER per **page** and the **overall** CER of a text. The reasoning behind this is that the material OCR-D mainly aims at (historical prints) is very heterogeneous: Some pages might have an almost simplistic layout while others can be highly complex and difficult to process. Providing only an overall CER would cloud these differences between pages.

At this point we only provide a CER per page; an overall CER might be calculated as a weighted aggregate at a later stage.

##### Word Error Rate (WER)

The word error rate (WER) is closely connected to the CER. While the CER focusses on differences between characters, the WER represents the percentage of words incorrectly recognized in a text.

CER and WER share categories of errors, and the WER is similarly calculated:

$WER = \frac{i_w + s_w + d_w}{n_w}$

where $i_w$ is the number of inserted, $s_w$ the number of substituted, $d_w$ the number of deleted and $n_w$ the total number of words.

More specific cases of WER consider only the "significant" words, omitting e.g. stopwords from the calculation.

###### WER Granularity

In OCR-D we distinguish between the WER per **page** and the **overall** WER of a text. The reasoning here follows the one of CER granularity.

At this point we only provide a WER per page; an overall WER might be calculated at a later stage.

#### Bag of Words

In the "Bag of Words" model a text is represented as a set of its word irregardless of word order or grammar; Only the words themselves and their number of occurence are considered.

Example:

![A sample paragraph in German Fraktur](https://pad.gwdg.de/uploads/4d33b422-6c77-436c-a3e6-bf27e67dc203.jpg)

> Eine Mondfinsternis ist die Himmelsbegebenheit welche sich zur Zeit des Vollmondes ereignet, wenn die Erde zwischen der Sonne und dem Monde steht, so daß die Strahlen der Sonne von der Erde aufgehalten werden, und daß man so den Schatten der Erde in dem Monde siehet. In diesem Jahre sind zwey Monfinsternisse, davon ist ebenfalls nur Eine bey uns sichtbar, und zwar am 30sten März des Morgens nach 4 Uhr, und währt bis nach 6 Uhr.

To get the Bag of Words of this paragraph a set containing each word and its number of occurence is created:

$BoW$ =

```json=
{
    "Eine": 2, "Mondfinsternis": 1, "ist": 2, "die": 2, "Himmelsbegebenheit": 1, 
    "welche": 1, "sich": 1, "zur": 1,  "Zeit": 1, "des": 2, "Vollmondes": 1,
    "ereignet,": 1, "wenn":1, "Erde": 3, "zwischen": 1, "der": 4, "Sonne": 2,
    "und": 4, "dem": 2, "Monde": 2, "steht,": 1, "so": 2, "daß": 2, 
    "Strahlen": 1, "von": 1, "aufgehalten": 1, "werden,": 1, "man": 1, "den": 1, 
    "Schatten": 1, "in": 1, "siehet.": 1, "In": 1, "diesem": 1, "Jahre": 1, 
    "sind": 1, "zwey": 1, "Monfinsternisse,": 1, "davon": 1, "ebenfalls": 1, "nur": 1, 
    "bey": 1, "uns": 1, "sichtbar,": 1, "zwar": 1, "am": 1, "30sten": 1, 
    "März": 1, "Morgens": 1, "nach": 2, "4": 1, "Uhr,": 1, "währt": 1, 
    "bis": 1, "6": 1, "Uhr.": 1
}
```

### Layout Evaluation

For documents with a complex structure, looking at the recognized text's accuracy alone is often insufficient to accurately determine the quality of OCR. An example can help to illustrate this: in a document containing two columns, all characters and words may be recognized correctly, but when the two columns are detected by layout analysis as just one, the OCR result will contain the text for the first lines of the first and second column, followed by the second lines of the first and second column asf., rendering the sequence of words and paragraphs in the Ground Truth text wrongly, which defeats almost all downstream processes.

While the comprehensive evaluation of OCR with consideration of layout analysis is still a research topic, several established metrics can be used to capture different aspects of it.

#### Reading Order

Reading order describes the order in which segments on a page are intended to be read. While the reading order might be easily obtained in monographs with a single column where only a few page segments exist, identifying the reading order in more complex layouts (e.g. newspapers or multi-column layouts) can be more challenging.

Example of a simple page layout with reading order:

![A sample page in German Fraktur with a simple page layout showing the intended reading order](https://pad.gwdg.de/uploads/bc5258cb-bf91-479e-8a91-abf5ff8bbbfa.jpg)

(<http://resolver.sub.uni-goettingen.de/purl?PPN1726778096>)

Example of a complex page layout with reading order:

![A sample page in German Fraktur with a complex page layout showing the intended reading order](https://pad.gwdg.de/uploads/100f14c4-19b0-4810-b3e5-74c674575424.jpg)

(<http://resolver.sub.uni-goettingen.de/purl?PPN1726778096>)

#### IoU (Intersection over Union)

Intersection over Union is a term which describes the degree of overlap of two regions of a (document) image defined either by a bounding box or polygon. Example:

![A sample heading in German Fraktur illustrating a Ground Truth bounding box and a detected bounding box](https://pad.gwdg.de/uploads/62945a01-a7a7-48f3-86c2-6bb8f97d67fe.jpg)

(where green represents the Ground Truth and red the detected bounding box)

Given a region A with an area $area_1$, a region B with the area $area_2$, and their overlap (or intersection) $area_o$, the IoU can then be expressed as

$IoU = \frac{area_o}{area_1+area_2-area_o}$

where $area_1+area_2-area_o$ expresses the union of the two regions ($area_1+area_2$) while not counting the overlapping area twice.

The IoU ranges between 0 (no overlap at all) and 1 (the two regions overlap perfectly). Users executing object detection can choose a [threshold](#Threshold) that defines which degree of overlap must be given to define a prediction as correct. If e.g. a threshold of 0.6 is chosen, all prediction that have an IoU of 0.6 or higher are correct.

In OCR-D we use IoU to measure how well segments on a page are recognized during the segmentation step. The area of one region represents the area identified in the Ground Truth, while the second region represents the area identified by an OCR-D processor.

### Resource Utilization

Last but not least, it is important to collect information about the resource utilization of each processing step, so that informed decisions can be made when e.g. having to decide between results quality and throughput speed.

#### CPU Time

CPU time is the time taken by the CPU to process an instruction. It does not include idle time.

#### Wall Time

Wall time (or elapsed time) is the time taken by a processor to process an instruction including idle time.

#### I/O

I/O (input / output) is the number of bytes read and written during a process.

#### Memory Usage

Memory usage is the number of bytes the process allocates in memory (RAM).

#### Disk Usage

Disk usage is the number of bytes the process allocates on hard disk.

### Unicode Normalization

In Unicode there can be multiple ways to express characters that have multiple components, such as a base letter and an accent. For evaluation it is essential that both Ground Truth and OCR results are normalized *in the same way* before evaluation.

For example, the letter `ä` can be expressed directly as `ä` (`U+00E4` in Unicode) or as a combination of `a` and `◌̈` (`U+0061 + U+0308`). Both encodings are semantically equivalent but technically different.

Unicode has the notion of *normalization forms* to provide canonically normalized text. The most common forms are *NFC* (Normalization Form Canonical Composed) and *NFD* (Normalization Form Canonical Decomposed). When a Unicode string is in NFC, all decomposed codepoints are replaced with their decomposed equivalent (e.g. `U+0061 + U+0308` to `U+00E4`). In an NFD encoding, all decomposed codepoints are replaced with their composed equivalents (e.g. `U+00E4` to `U+0061 + U+0308`).

<!-- There's also NFKC and NFKD - necessary to explain? -->

In accordance with the concept of [GT levels in OCR-D](https://ocr-d.de/en/gt-guidelines/trans/trLevels.html), it is preferable for strings to be normalized as NFC.

The Unicode normalization algorithms rely on data from the Unicode database on equivalence classes and other script- and language-related metadata. For graphemes from the Private Use Area (PUA), such as MUFI, this information is not readily available and can lead to inconsistent normalization. Therefore, it is essential that evaluation tools normalize PUA codepoints in addition to canonical Unicode normalization.

<!-- Reference to GT rules here? -->

### Metrics Not in Use Yet

The following metrics are not part of the MVP (minimal viable product) and will (if ever) be implemented at a later stage.

#### GPU Metrics

##### GPU Time

GPU time is the time a GPU (graphics card) spent processing instructions

##### GPU Avg Memory

GPU avg memory refers to the average amount of memory of the GPU (in GiB) that was used during processing.

#### Text Evaluation

##### Flexible Character Accuracy Measure

The flexible character accuracy measure has been introduced to mitigate a major flaw of the CER: The CER is heavily dependent on the reading order an OCR engine detects; When content blocks are e.g. mixed up or merged during the text recognition step but single characters have been perfectly recognized, the CER is still very low.

The flexible character accuracy measure circumvents this effect by splitting the recognized text and the Ground Truth in smaller chunks and measure their partial edit distance. After all partial edit distances have been obtained, they are summed up to receive the overall character accuracy measure.

The algorithm can be summarized as follows:

> 1. Split the two input texts into text lines
> 2. Sort the ground truth text lines by length (in descending order)
> 3. For the first ground truth line, find the best matching OCR result line segment (by minimising a penalty that is partly based on string edit distance)
> 4. If full match (full length of line)
> a. Mark as done and remove line from list
> b. Else subdivide and add to respective list of text lines; resort
> 5. If any more lines available repeat step 3
> 6. Count non-matched lines / strings as insertions or deletions (depending on origin: ground truth or result)
> 7. Sum up all partial edit distances and calculate overall character accuracy

(C. Clausner, S. Pletschacher and A. Antonacopoulos / Pattern Recognition Letters 131 (2020) 390–397, p. 392)

#### Layout Evalutation

##### mAP (mean Average Precision)

###### Precision and Recall

**Precision** is a means to describe how accurate a model can identify an object within an image. The higher the precision of a model, the more confidently we can assume that a prediction (e.g. the model having identified a bicycle in an image) is correct. A precision of 1 indicates that each identified object in an image has been correctly identified (true positives) and no false positives have been detected. As the precision value descreases, the result contains more and more false positives.

**Recall**, on the other hand, measures how well a model performs in finding all instances of an object in an image (true positives), irregardless of false positives. Given a model tries to identify bicycles in an image, a recall of 1 indicates that all bicycles have been found by the model (while not considering other objects that have been falsely labelled as a bicycle).

###### Prediction Score

When a model tries to identify objects in an image, it predicts that a certain area in an image represents said object with a certain confidence or prediction score. The prediction score varies between 0 and 1 and represents the percentage of certainty of having correctly identified an object. Given a model tries to identify ornaments on a page. If the model returns an area of a page with a prediction score of 0.6, the model is "60% sure" that this area is an ornament. If this area is then considered to be a positive, depends on the chosen threshold.

###### Thresholds

A threshold is a freely chosen number between 0 and 1. It divides the output of a model into two groups: Outputs that have a prediction score or IoU greater than or equal to the threshold represent an object. Outputs with a prediction score or IoU below the threshold are discarded as not representing the object.

Example:
Given a threshold of 0.6 and a model that tries to detect bicycles in an image. The model returns two areas in an image that might be bicycles, one with a prediction score of 0.4 and one with 0.9. Since the threshold equals 0.6, the first area is tossed and not regarded as bicycle while the second one is kept and counted as recognized.

###### Precision-Recall-Curve

Precision and recall are connected to each other since both depend on the true positives detected. A precision-recall-curve is a means to balance these values while maximizing them.

Given a dataset with 100 images in total of which 50 depict a bicycle. Also given a model trying to identify bicycles on images. The model is run 7 times using the given dataset while gradually increasing the threshold from 0.1 to 0.7.

| run | threshold | true positives | false positives | false negatives |precision | recall |
|-----|-----------|----------------|-----------------|-----------------|----------|--------|
| 1   | 0.1       |  50            | 25              | 0               | 0.66     | 1      |
| 2   | 0.2       |  45            | 20              | 5               | 0.69     | 0.9    |
| 3   | 0.3       |  40            | 15              | 10              | 0.73     | 0.8    |
| 4   | 0.4       |  35            | 5               | 15              | 0.88     | 0.7    |
| 5   | 0.5       |  30            | 3               | 20              | 0.91     | 0.6    |
| 6   | 0.6       |  20            | 0               | 30              | 1        | 0.4    |
| 7   | 0.7       |  10            | 0               | 40              | 1        | 0.2    |

For each threshold a pair of precision and recall can be computed and plotted to a curve:

![A sample precision/recall curve](https://pad.gwdg.de/uploads/2d3c62ff-cab4-4a12-8043-014fe0440459.png)

This graph is called Precision-Recall-Curve.

###### Average Precision

The average precision (AP) describes how well a model can detect objects in an image for recall values over 0 to 1 by computing the average of all precisions given in the Precision-Recall-Curve. It is equal to the area under the curve.

![A sample precision/recall curve with highlighted area under curve](https://pad.gwdg.de/uploads/799e6a05-e64a-4956-9ede-440ac0463a3f.png)

The Average Precision can be computed with the weighted mean of precision at each confidence threshold:

$AP = \displaystyle\sum_{k=0}^{k=n-1}[r(k) - r(k+1)] * p(k)$

with $n$ being the number of thresholds and $r(k)$/$p(k)$ being the respective recall/precision values for the current confidence threshold $k$.

Example:
Given the example above, we get:

$$
\begin{array}{ll}
AP &  = \displaystyle\sum_{k=0}^{k=n-1}[r(k) - r(k+1)] * p(k) \\
& = \displaystyle\sum_{k=0}^{k=6}[r(k) - r(k+1)] * p(k) \\
& = (1-0.9) * 0.66 + (0.9-0.8) * 0.69 + \text{...} + (0.2-0) * 1\\
& = 0.878
\end{array}
$$

###### mAP (mean Average Precision)

The mean Average Precision is a metric used to measure how accurate an object detector is. [As stated](#Thresholds), a threshold can be chosen freely, so there is some room for errors when picking one single threshold. To mitigate this effect, the mean Average Precision metric has been introduced which considers a set of IoU thresholds to determine the detector's performance. It is calculated by first computing the Average Precision for each IoU threshold and then finding the average:

$mAP = \displaystyle\frac{1}{N}\sum_{i=1}^{N}AP_i$ with $N$ being the number of thresholds.

##### Scenario-Driven Performance Evaluation

Scenario-driven performance evaluation as described in [Clausner et al., 2011](https://primaresearch.org/publications/ICDAR2011_Clausner_PerformanceEvaluation) is currently the most comprehensive and sophisticated approach to evaluate OCR success with consideration of layout.

The approach is based on the definition of so called evaluation scenarios, which allow the flexible combination of a selection of metrics together with their weights, targeted at a specific use case.

## Evaluation JSON schema

<!-- normative -->

The results of an evaluation should be expressed in JSON according to
the [`ocrd-eval.json`](https://ocr-d.de/en/spec/ocrd-eval.schema.json).

## Tools

See [OCR-D workflow guide](https://ocr-d.de/en/workflows#evaluation).

## References

* CER/WER:
  * <https://sites.google.com/site/textdigitisation/qualitymeasures>
  * <https://towardsdatascience.com/evaluating-ocr-output-quality-with-character-error-rate-cer-and-word-error-rate-wer-853175297510#5aec>
* IoU:
  * <https://medium.com/analytics-vidhya/iou-intersection-over-union-705a39e7acef>
* mAP:
  * <https://blog.paperspace.com/mean-average-precision/>
  * <https://jonathan-hui.medium.com/map-mean-average-precision-for-object-detection-45c121a31173>
* BoW:
  * <https://en.wikipedia.org/wiki/Bag-of-words_model>
* FCA:
  * <https://www.primaresearch.org/www/assets/papers/PRL_Clausner_FlexibleCharacterAccuracy.pdf>
* More background on evaluation of OCR
  * <https://doi.org/10.1145/3476887.3476888>
  * <https://doi.org/10.1515/9783110691597-009>
