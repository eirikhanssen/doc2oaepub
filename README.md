# doc2oaepub
Formerly known as doc2jats. Renamed because JATS is only one of the target goals.
**doc2oaepub** is short for **document to open access electronic publishing**
For now we have html-output. But the aim is to have html, ePub and JATS output.
an XProc pipeline for flattening a document (.docx or .odt), then generating semantic html (and later also ePub3, and JATS xml) from it.
## Usage:
```doc2epub.py sample.docx```
## How it works
The python wrapper script will unpack to a folder based on the docx-filename
Then it will pass the location of the extracted xml-files to an XProc pipeline that based on the xml-markup of the document and the used paragraph styles and heading styles will generate a semantic html5 version of the document.
Conversion to ePub and JATS is planned.
## Academic papers
Target type of documents are academic documents with a lot of citations. If working with several journals, a journal short name can be specified, and this will be inserted in the html document as an attribute in the html root element. This can be used for styling purposes if different journals would like to use different theme for the header for instance.
Later when converting to ePub and JATS it is possible to use this value to inject journal specific content.
- The XProc pipeline automatically generates id's for references in the reference list based on authors and year.
- The pipeline then does some search in the document's text using regular expressions to locate citations and automatically tries to create links from citations to the reference list.
- The pipeline analyses if there are any citation links that lead ot non-existing references, or if there are duplicate reference list item ids, or if there are entries in the reference list that have not been cited/linked to.
  - If any of these hold true, a warning is displayed in the terminal and error logfile.
