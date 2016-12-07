# Canadians at War

A data science project gathering data from multiple sources about the role of individual Canadian
soldiers in the First World War and linking it together for further analysis.

For more information on individual datasets, see the README files in individual folders.

## Setting up the project

To run this project, you need Python and a Postgres 9.5+ database.

Run `./setup.sh` in the root directory. This will create the database and load it with the available datasets.

### Downloading the original data sets

The data sets will be downloaded to `tmp` in each directory. In order to avoid overtaxing the websites hosting
this data, existing datasets will not be downloaded twice.

Data sets that cannot be downloaded automatically were included with this repository.