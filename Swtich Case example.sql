Select top 100    Case    
  When (
   (
isNull(pnh.medicalbenefitsoption2,'') = 'Y'
   ) 
   OR (
isNull(pnh.medicalbenefitsoption3,'') = 'Y'
   )
  )    THEN SUBSTRING(RTRIM(LTRIM(pnh.PhysicianName)),1,30)  
  When (
   (
isNull(pnh.medicalbenefitsoption2,'') = 'Y'
   ) 
   OR (
isNull(pnh.medicalbenefitsoption3,'') = 'Y'
   )
  )    THEN SUBSTRING(RTRIM(LTRIM(pnh.PhysicianName2)),1,30)  
  ELSE NULL   
 end as PrescriptionDrugPlanEnrollment
,pnh.userid from procNewhires pnh order by pnh.createdDatetime desc