# Canadian Online War Memorial war dead

Fetches, parses and saves the list of Canadian war dead used to create the
Canadian Online War Memorial.

> The names found in the Canadian Virtual War Memorial are those found in
  the Books of Remembrance. They contain the names of Canadians who fought
  in wars and died either during or after them. Together, they commemorate
  the lives of more than 118,000 Canadians who, since Confederation, have
  made the ultimate sacrifice while serving our country in uniform.

## Good to know

* This data set contains war dead from various wars, not only the First
  World War.
* The countries and localities are saved as numbers. The value of some of
  these numbers is not known.
* The Commonwealth War Grave Commissions grave, cemetery and locality IDs
  are included with this dataset, but may not be up to date. The cemetery
  descriptions in this data set are the same as those from the CWGC.
* The root URL for cemetary image files is
  http://www.virtualmemorial.gc.ca/cm_image/
* The root URL for main image files is unknown. However, they are always
  scans of the *First World War Book of Remembrance*. Images are titled
  ww1*.jpg, where the wildcard indicates the page number in the book.
  ww1306.jpg means the soldier is listed at page 306 of the book.
* There is a small number of duplicates in the database. A few soldiers
  with identical information that point to the same grave are returned.

Source: http://open.canada.ca/data/en/dataset/089fc8e5-1340-4e8a-a7e4-f6eb320a5b6e (URL for first 500 results)