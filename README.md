# mjoy
Subset of the Programming Language Joy with Turtle Graphics



**Referenz für mjoy**
vom  2017-11-18

Definition von Bezeichnern

_bezeichner1_ **==** _wort1 wort2 wort3 ..._
_bezeichner2_ **==** _wort4 wort5 wort6 ..._

Beispiel eintippen:

makelist (... num -- liste) == [] swap [cons] times       \&lt;Enter\&gt;
&#39;anfang 10 20 30 40 50 5 makelist &#39;ende stack reverse print     \&lt;Enter\&gt;
... anfang [10 20 30 40 50] ende

Befehle für den Stack

der Parameterstapel (stack) ist eine Liste

**stack**                         --        _liste_
Schiebt den Stapel als _liste_ auf den Stapel.

_liste_ **unstack**
die _liste_ wird zum neuen Stapel.

**clear**
Löscht den Stapel.

_xwert_ **dup**                 --        _xwert xwert_
Schiebt eine Extrakopie vom _xwert_ auf den Stapel.

_wert_ **pop**                 --
Entfernt _wert_ von der Spitze des Stapels.

_xwert ywert_ **swap**         --        _ywert xwert_
Vertauscht _xwert_ und _ywert_ an der Spitze des Stapels.

_x y z_ **rotate**                 --        _z y x_
Vertauscht _x_ und _z_.

_x y z_ **rollup**                 --        _z x y_

_x y z_ **rolldown**                 --        _y z x_

... _num_ **index**                 --        _stackwert_
Pickt eine Kopie vom _stackwert_ mit der Position _num_ relativ zur Stapelspitze aus
dem Stapel und schiebt ihn auf den Stapel;
mit _num_ = 1 -\&gt; erster Wert, _num_ = 2 -\&gt; zweiter Wert, ...

_xwert [programm]_ **dip**         --        ...  _xwert_
Speichert den _xwert_, führt das _programm_ aus, schiebt _xwert_ auf den Stapel zurück.

**id**                         --
Identitätsfunktion, macht gar nix; als Platzhalter für eine Funktion.

**.s**                         --
Gibt den Inhalt des Stapels aus.                (jetzt Monadenverhalten)

Befehle für Ein/Ausgabe

_wert_   **.**                                 --
Gibt den obersten _wert_ vom Stapel aus.        (jetzt Monadenverhalten)

_liste_ **print**                         --
Gibt die _liste_ ohne eckige Klammern aus.        (jetzt Monadenverhalten)

_fname_ **loadstring**                 --        _string_
Lädt den Inhalt einer Textdatei und legt ihn als Charliste auf dem Stapel ab.
                                                (jetzt Monadenverhalten)

_fname__string_ **savestring**         --
Speichert die Charliste (string) als Text in einer Textdatei ab.
                                                (jetzt Monadenverhalten)

Befehle für Listenverarbeitung

**[**_wert1 wert2 wert3 ..._**]**

_liste_ **first**                 --        _wert
wert_ ist der erste Wert der nichtleeren _liste_.

_liste1_ **rest**                 --        _liste
liste_ ist die Restliste der nichtleeren _liste1_ ohne den ersten Wert.

_wert1 liste1_ **cons       ** --        _liste_
die _liste_ entsteht aus der _liste1_ mit neuem ersten _wert1_.

_liste1 wert1_ **swons**         --        _liste_
die _liste_ entsteht aus der _liste1_ mit neuem ersten _wert1_.

_liste1_ **uncons**                 --        _wert liste_
Legt den _first_ und den _rest_ der nichtleeren _liste1_ auf den Stapel.

_liste1_ **unswons**         --        _liste wert_
Legt den _rest_ und den _first_ der nichtleeren _liste1_ auf den Stapel.

_liste1_ **reverse**                 --        _liste_
Die Reihenfolge der Elemente der _liste1_ wird umgekehrt zur neuen _liste_.

_liste_ **size**                 --        _num
num_ ist die Anzahl der Elemente der _liste_.

_liste1 num_ **take**         --        _liste_
Eine _liste_ mit den ersten _num_ Elementen der _liste1_.

_liste1 num_ **drop**         --        _liste_
Eine kopierte _liste_ ohne den ersten _num_ Elementen der _liste1_.

_liste1 liste2_ **concat**         --        _liste_
Die _liste_ ist die Verkettung der _liste1_ und _liste2_.

_liste1 liste2_ **swoncat**         --        _liste_

_num_ **iota**                 --        _liste_
Generiert eine _liste_ von Zahlen von 1 bis _num_.

_liste num_ **at**                 --        _element__num_
Pickt das _element_num aus der Liste.

_liste1 num wert_ **set**         --        _liste_

_matrix1_ **trans**                 --        _matrix_

_wert1 wert2_ **pair**         --        _[wert1 wert2]_

_[wert1 wert2]_ **unpair**         --        _wert1 wert2_

Befehle für das Verarbeiten von Dict-Listen

**[**_key1 wert1 key2 wert2 ... ..._**]**

_dict key_ **dictget**                 --        _wert
dict key_ **get**                         --        _wert_
Holt den _wert_ zum _key_ aus dem _dict_ hervor.

_dict1 key wert_ **dictput**                 --        _dict
dict1 key wert_ **put**                 --        _dict_
Legt einen neuen _wert_ zum _key_ in einem _dict_ an mit _dict1_ als Kopie.

Mathematische Funktionen

_num1 num2_ **+**                 --        _num
num_ ist das Ergebnis der Addition von _num1_ und _num2_.

_num1 num2_   **-**                 --        _num
num_ ist das Ergebnis der Subtraktion _num2_ von _num1_.

_num1 num2_ **\***                 --        _num
num_ ist das Produkt von _num1_ und _num2_.

_num1 num2_ **/**                 --        _num
num_ ist der Quotient von _num1_ dividiert durch _num2_.

_num1 num2_ **pow**         --        _num_

_num1_ **int       **         --        _num
num_ ist der ganzzahlige Anteil von _num1_.

_num1_ **abs**                 --        _num_

_num1_ **neg**                 --        _num
num_ ist der negative Wert von _num1_.

_num1_ **round**                 --        _num_

_num1_ **exp**                 --        _num_

_num1_ **log**                 --        _num_

_num1_ **log10**                 --        _num_

**pi**                         --        3.141592653589793

_radiwinkel_ **sin**                 --        _num
num_ ist der Sinus vom _winkel_ im Bogenmaß.

_radiwinkel_ **cos**                 --        _num
num_ ist der Cosinus vom _winkel_ im Bogenmaß.

_radiwinkel_ **tan**                 --        _num_

_num1_ **asin**                 --        _radiwinkel_

_num1_ **acos**                 --        _radiwinkel_

_num1_ **atan**                 --        _radiwinkel_

_num1_ **sqrt**                 --        _num
num_ ist die Quadratwurzel von _num1_.

_[num1 num2 ... numn]_ **sum**                 --        _num_
Summe aller Elemente der Liste.

Logische Funktionen

**true**                         --        _true_
Schiebt den Wert true auf den Stapel.

**false**                         --        _false_
Schiebt den Wert false auf den Stapel.

_bool_ **not**                 --        _bool_
Logische Negation für Wahrheitswerte.

_bool1 bool2_ **and**         --        _bool_
Logische Konjunktion für Wahrheitswerte.

_bool1 bool2_ **or**                 --        _bool_
Logische Disjunktion für Wahrheitswerte.

_wert1 wert2_   **=**                 --        _bool
charliste1 charliste2  _   **=       ** --        _bool_
Prüft, ob _wert1_ gleich _wert2_ ist, und legt den Wahrheitswert auf den Stapel.

_wert1 wert2_ **\&lt;\&gt;**         _--        bool_

_wert1 wert2_ **!=**         --        bool

_wert1 wert2_   **\&lt;**                         --        _bool
charliste1 charliste2_   **\&lt;**         --        _bool_

_wert1 wert2_   **\&gt;**                 --        _bool_

_wert1 wert2_ **\&lt;=**         --        _bool_

_wert1 wert2_ **\&gt;=**         --        _bool_

_wert_ **null**                 --        _bool_

_wert_ **list**                 --        _bool_

_wert_ **logical**                 --        _bool_

_wert_ **type &#39;null =**         --        _bool
wert_ **type &#39;cons =**         --        _bool
wert_ **type &#39;ident =**         --        _bool
wert_ **type &#39;float =**         --        _bool
wert_ **type &#39;char =**         --        _bool
wert_   **&#39;undef   =**         --        _bool_

_wert liste_ **in**                 --        _bool_

Befehle für die Ablaufsteuerung

**&#39;**  _bezeichner_                        --        _bezeichner_
Der _bezeichner_, der dem Quote folgt, wird auf den Stapel geschoben.

_bool [dann] [sonst]_ **if**                 --        ...
Wenn _bool_ = true -\&gt; _dann_ wird ausgeführt;
wenn _bool_ = false -\&gt; _sonst_ wird ausgeführt.

_bool [dann] [sonst]_ **branch**         --        ...        \*wie **if**

_werti [[wert1 rest1...] [wert2 rest2...] ... [wertn restn...]]_ **select**         --        _[resti...]_

_[[bool1 rest1...] [bool2 rest2...] ... [true restn...]]_ **cond**         --        _..._

_num [programm]_ **times       ** --        ...
_num_-mal wird das _programm_ ausgeführt.

_[test] [programm]_ **while**         --        ...
Wiederholt, wenn das Ausführen von _test_ den Wert true ergibt wird
das _programm_ ausgeführt.

_[programm]_ **i**                         --        ...
Führt das _programm_ aus.

_[programm]_ **try               ** --        ...  _[hinweis]_
Führt das _programm_ aus und schiebt einen (möglicherweise leeren) _hinweis_ auf
eine Exception auf den Stapel.

_liste [programm]_ **step**                 --        ...

_liste1 [programm]_ **map**         --        _liste_

_liste zero [programm]_ **fold**         --        _querresultat_

_liste1 [prädikat]_ **filter**                 --        _liste_

_num [programm]_ **&#39;!**                 --        ...
_[monade] [programm]_ **&#39;!**         --        ...                (Monadenverhalten)
Erst wird die primitive Monade _num_ oder die _[monade]_ ausgeführt -
also ein Seiteneffekt geschied. Dannach wird das _[programm]_ ausgeführt.
Die Monade steht am Ende einer Sequenz/eines Programms.

Misc Befehle

_wert_ **type**         --        _datentypbezeichner_

   null    []
   cons    [x y z ...]
   ident    abc
   integer  \*intern  (123)
   float    -3.1415e-100
   char    &quot;A&quot;
   string  \*intern  (&quot;abc&quot;)

_num1 num2 num3_ **rgb**         --        _num_
Berechnet den Rot-Grün-Blau-Wert.

_zeichen1_ **upper**                 --        _zeichen
zeichen_ ist der Ansiuppercase von _zeichen1_.

_zeichen1_ **lower**                 --        _zeichen
zeichen_ ist der Ansilowercase von _zeichen1_.

_num_ **chr**         --        _zeichen_

_zeichen_ **ord**         --        _num_

_ident_ **name**         --        _charliste_

_ident_ **body**         --        _num_
                --        _liste_

_charliste_ **parse**                 --        _liste_
Wandelt die Stringdarstellung in eine _liste_ von internen Darstellungen um.

_wert_ **tostr**                 --        _charliste_
Wandelt den _wert_ in eine Stringdarstellung um.

**gc**                 --
Erzwingt eine Garbage Collection, die sonst nur spontan auftritt,
wenn die Freelist erschöpft ist.

_wert_ **out**         --                        \*Seiteneffekt
Möglichkeit, um Fehlern auf die Schliche zu kommen.

**quit**                 --
Beendet den Interpreter.

**identlist**         --        _liste_
Liste mit den verwendeten Bezeichnern.

Befehle für Turtlegraphic

die Turtle dreht sich im Bogenmaß (Radiant); eine Umdrehung ist 2pi.

**2pi**                         --        6.283185307179586

_degreewert_ **rad**         --        _radiantwert_
Grad-Wert wird in Radiant-Wert umgerechnet.

_radiantwert_ **deg**         --        _degreewert_
Radiant-Wert wird in Grad-Wert umgerechnet.

**offs**  ==  id                _oder       _         **offs**  ==  rad
für Radiantwerte        _oder_                für Degreewerte
90 rad turn                _oder_                90 turn

**init**         --        [stack [] x 0 y 0 angle 0 pen true color 0 size 1 brush 16777215]
Initialisierung der Turtle. Die Turtle ist ein dict (Dict-Liste).

_dict_ **draw**                         --                        (jetzt Monadenverhalten)
Zeichnet die Spur der Turtle.

_dict xwert ywert_ **moveto**         --        _dict_
Bewegt die Turtle auf den (x,y)-Wert.
Aufgepasst: die Bildschirmanzeige liegt im 4. Quadranten also (x,-y).

_dict relax relay_ **moverel**         --        dict
Relatives moveto.

_dict distwert_ **move**                 --        _dict_
Die Turtle wird um den _distwert_ in die aktuelle Ausrichtung bewegt.

_dict winkel_ **turnto**                 --        _dict_
Legt die aktuelle Ausrichtung der Turtle fest.

_dict relawinkel_ **turn**                 --        _dict_
Verändert die aktuelle Ausrichtung der Turtle um den _relawinkel_.

_dict_ **penup**                         --        _dict_
Hebt den Zeichenstift der Turtle -\&gt; es werden keine Linien gemalt.

_dict_ **pendown**                         --        _dict_
Senkt den Zeichenstift der Turtle -\&gt; es kann wieder gemalt werden.

_dict num_ **pencolor**                 --        _dict_
Setzt die Zeichenstiftfarbe auf _num_.

_dict num_ **pensize**                 --        _dict_
Legt die Breite des Zeichenstiftes fest.

_dict num_ **brushcolor**                 --        _dict_
Legt die Farbe für das Ausfüllen von Flächen fest.

_dict radius_ **circle**                 --        _dict_
Malt einen ausgefüllten Kreis mit dem _radius_ über den letzten Punkt.

_dict_ **rectangle**                         --        _dict_
Malt ein ausgefülltes Rechteck über die letzten zwei Punkte.

**colors**                 --        [red 255 black 0 blue 16711680 white 16777215 green 32768 aqua 16776960 darkgray 8421504 fuchsia 16711935 gray 8421504 lime 65280 lightgray 12632256 maroon 128 navy 8388608 olive 32896 purple 8388736 silver 12632256 teal 8421376 yellow 65535 gold 55295 orange 42495]

_liste_ **showgraph       **         --                                \*intern
Die Spur, codiert als Paare in der _liste_, wird gezeichnet.        (jetzt Monadenverhalten)

**start**                                 --        _dict_
Beginn mit einer Turtle in der Bildmitte.

_dict_        **;**                         --        _dict       _                 (jetzt Monadenverhalten)
Kann für Interaktives Zeichnen mit der Turtle genutz werden (zB:        50 move **;**  ).

**mjoy it ...**

