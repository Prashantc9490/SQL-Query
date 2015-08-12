# SQL-Query
Query which gives quama separated values.

select 
CPL.PatternCode as Document_Code, 
CPL.PatternName as Document_Title, 
CPL.Keywords as Keywords, 
AREA.Name as Folder, 
LOC.Name as Display_Location,
--TGRP.Name as Group_Assigned 

STUFF((SELECT ', '+ TGRP1.Name 
               FROM t_cplindex CPL1
left outer join T_cplPostingLocation Post1 on Post1.PostingID = CPL1.ID
left outer Join T_cplLocation LOC1 on Post1.LocationID = LOC1.ID
left outer join T_cplArea AREA1 on AREA1.ID = CPL1.AreaID
left outer join T_cbaAccessControlList GRP1 on GRP1.GrantingObjectId = CPL1.ID
left outer join T_cusGroup TGRP1 on TGRP1.id = GRP1.RequestingObjectId
              WHERE CPL1.PatternType = 9 and CPL1.indexmode=1 and CPL1.PatternCode= CPL.PatternCode
           GROUP BY TGRP1.Name
            FOR XML PATH(''), TYPE).value('.','VARCHAR(max)'), 1, 1, '') as Group_Assigned

from t_cplindex CPL
left outer join T_cplPostingLocation Post on Post.PostingID = CPL.ID
left outer Join T_cplLocation LOC on Post.LocationID = LOC.ID
left outer join T_cplArea AREA on AREA.ID = CPL.AreaID
left outer join T_cbaAccessControlList GRP on GRP.GrantingObjectId = CPL.ID
left outer join T_cusGroup TGRP on TGRP.id = GRP.RequestingObjectId
where 
CPL.indexmode=1

GROUP BY CPL.PatternCode, CPL.PatternName, AREA.Name, LOC.Name
order by CPL.PatternName
