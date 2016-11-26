# Commonwealth War Graves Commission war dead

Fetches, parses and saves the list of war dead from the Commonwealth War Graves
Commission.

## Good to know

* The spelling for first and last names might differ from those of the Canadian
  Expeditionary Force data set.
* "War dead" does not necessarily imply that the person died during the war, or
  from combat action. These records simply provide details about the war graves
  managed by the CWGC.
* The cemetary name from both tables can be used as a primary key. They are
  confirmed to be unique, and all graves have a valid cemetary name.

Source: http://cwgc.org/find-war-dead.aspx (criteria: First World War, Canadian
Forces)

Source: http://www.cwgc.org/find-a-cemetery.aspx (criteria: First World War)

The CWGC is an ASP.NET WebForms website that makes it nearly impossible to
fetch the data with curl, so a copy of the data set is included in this
repository.