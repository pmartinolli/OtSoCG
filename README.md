# On the Shoulders of Cloud Giants: Citation Practices in the Tabletop Role-Playing Game Publishing 

Combining Wikidata, SPARQL and R Studio/Javascript to analyze and display of the citation network of TTRPGs from 1974.


UPDATE 2024-02-08 : The dataviz part of the project is currently developed in [Javascript on ObservableHQ](https://observablehq.com/@pascaliensis/on-the-shoulders-of-cloud-giants)



## [Map graph of the games, weighted by citations](https://github.com/pmartinolli/OtSoCG/blob/master/output/OtSoCG_with_map.pdf)

[Code in R](https://github.com/pmartinolli/OtSoCG/blob/master/R/OtSoCG_with_map.R)

[![OtSoCG snapshot](https://github.com/pmartinolli/OtSoCG/blob/master/output/OtSoCG_with_map.png)](https://github.com/pmartinolli/OtSoCG/blob/master/output/OtSoCG_with_map.pdf)

---

## [Chord diagram graph of the publishers](https://github.com/pmartinolli/OtSoCG/blob/master/output/OtSoCG_with_chorddiagram.pdf)

[Code in R](https://github.com/pmartinolli/OtSoCG/blob/master/R/OtSoCG_with_chorddiagram.R)

[![OtSoCG snapshot](https://github.com/pmartinolli/OtSoCG/blob/master/output/OtSoCG_with_chorddiagram.png)](https://github.com/pmartinolli/OtSoCG/blob/master/output/OtSoCG_with_chorddiagram.pdf)
[![OtSoCG snapshot](https://github.com/pmartinolli/OtSoCG/blob/master/output/OtSoCG_with_chorddiagram-detail.png)](https://github.com/pmartinolli/OtSoCG/blob/master/output/OtSoCG_with_chorddiagram.pdf)

---

## [Hierarchical edge bundling graph of the games](https://github.com/pmartinolli/OtSoCG/blob/master/output/OtSoCG_with_geom_conn_bundle_fancy.pdf)

[Code in R](https://github.com/pmartinolli/OtSoCG/blob/master/R/OtSoCG_with_geom_conn_bundle_fancy.R)

This code can be reused by providing a dataframe or a table, of any size, structured like : citing | category | cited | category

A more simple version of the code can be [found here](https://github.com/pmartinolli/OtSoCG/blob/master/R/OtSoCG_with_geom_conn_bundle_simple.R).

[![OtSoCG snapshot](https://github.com/pmartinolli/OtSoCG/blob/master/output/OtSoCG_with_geom_conn_bundle_fancy.png)](https://github.com/pmartinolli/OtSoCG/blob/master/output/OtSoCG_with_geom_conn_bundle_fancy.pdf)

---
## Wikidata

### SPARQL Queries

A dozen of [SPARQL queries are collected here](https://www.wikidata.org/wiki/User:Pmartinolli/OtSoCG) to extract data from Wikidata in CSV or JSON format.

### Indexing guidelines

Some guidelines at [WikiProject Board Games](https://www.wikidata.org/wiki/Wikidata:WikiProject_Board_Games) about improving TTRPG items.

### Identifiers

In 2019, I asked the creation of the [RPGGeek ID (P7226)](https://www.wikidata.org/wiki/Property:P7226). It would be nice to have an identifier for [LeGrog](http://www.legrog.org/), an awesome French TTRPG database.

## Local data on TTRPG

In the folder `\data`, you will find some CSV dataset with a stable URL. 

#### - [epigraph_data.csv](https://github.com/pmartinolli/OtSoCG/blob/master/data/epigraph_data.csv)

How the epigraphs are used in TTRPG games. [Details here](https://zotrpg.blogspot.com/2020/08/epigraphs-in-ttrpgs-12.html). [Détails ici](https://jdr.hypotheses.org/1332) et [ici](https://jdr.hypotheses.org/1401).

#### - [publisher_data.csv](https://github.com/pmartinolli/OtSoCG/blob/master/data/publisher_data.csv)

I made this table because all Wikidata items (games) aren't indexed with a Publisher property. This data fills partially the void.

#### - [ceasendesist_data.csv](https://github.com/pmartinolli/OtSoCG/blob/master/data/ceasendesist_data.csv)

List of the Cease & Desist affairs I know of. [Details here](http://zotrpg.blogspot.com/2020/08/cease-desist-orders-and-citation.html). [Détails ici](https://jdr.hypotheses.org/1199). Maybe there is an impact on the citation practices.

## About the project

### Data playing

On this [Google Colab](https://colab.research.google.com/drive/1gb9XBBNy3qniJ-aRlq1r_LtAue0wBNxy?usp=sharing), I am exploring and toying with the different sets of data.

### Storytelling the project

The whole project is loosely [explained in my blog](http://zotrpg.blogspot.com/search/label/on%20the%20shoulders%20of%20cloud%20giants) (explications épisodiques du projet [sur mon blogue en français](https://jdr.hypotheses.org/1163)).

### You can contribute

* By improving the data on Wikidata (especially the properties Publisher, Author and RPGGeek ID).
* By improving the code (for beauty, clarity or structure). The specific details to improve each graphs are documented in the R code.
* By pushing it on your social media [@pascaliensis](https://twitter.com/Pascaliensis).

### Acknowledgements 

* [Yan Holtz](https://www.yan-holtz.com/) for his https://www.r-graph-gallery.com/hierarchical-edge-bundling.html and https://www.data-to-viz.com/graph/edge_bundling.html
* [Michael Hahsler](https://michael.hahsler.net/SMU/ScientificCompR/code/map.R) and Sudheer Chelluboina for their function `map`.
* Mikhail Popov for his `WikidataQueryServiceR` package.
* Hadley et al. for their `tidyverse` and `dplyr` packages.
* Thomas Lin Pedersen for his `ggraph` package.
* Gábor Csárdi et al. for their `igraph` package.
* Zuguang Gu for his `circlize` package.
* Ross Ihaka and Robert Gentleman for the R language.
* The developers of RStudio and the PDF format.
* Caroline Patenaude, data librarian, for her workshops on R Studio.
* Simon Villeneuve, professor, for introducing me to Wikidata.

### This content is CC-BY 4.0 

Informations in the source code are pure facts, therefore they cannot be copyrighted. The curation of these informations, the links between them and the structure of their display are a work of edition. For this reason, I will be glad you aknowledge my name if you want to reuse them.

### Metadata / Métadonnées

* Author / Auteur : Pascal Martinolli

* Created / Créé le : 2019

* Most recent version / Dernière version : 2021-03-01

* Original format / format de fichier : R script

* License / Licence : [CC-BY](https://creativecommons.org/licenses/by/4.0/)

* Presented at, promoted through / Présenté à, diffusé via : [Twitter](https://twitter.com/Pascaliensis)

* Commments and collaborations are welcomed at / Commentaires et collaborations bienvenus : pascal.umontreal [at] gmail.com

* How to cite the project in your academic work : 
> Martinolli, Pascal. 2019. « On the Shoulders of Cloud Giants: citation practices in the tabletop role-playing game publishing. » Dataset and R language code. https://github.com/pmartinolli/OtSoCG

\
\
https://github.com/pmartinolli/OtSoCG
