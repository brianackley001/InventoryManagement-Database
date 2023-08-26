ALTER ROLE [db_datareader] ADD MEMBER [svc_inventory_management_dev];


GO
ALTER ROLE [db_datareader] ADD MEMBER [svc_inventory_manager_api];


GO
ALTER ROLE [db_datawriter] ADD MEMBER [svc_inventory_management_dev];


GO
ALTER ROLE [db_datawriter] ADD MEMBER [svc_inventory_manager_api];


GO
ALTER ROLE [db_owner] ADD MEMBER [svc_inventory_management_dev];

