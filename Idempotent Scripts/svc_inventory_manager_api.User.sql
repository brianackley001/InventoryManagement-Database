/****** Object:  User [svc_inventory_manager_api]    Script Date: 12/1/2019 9:44:28 PM ******/

GO
sys.sp_addrolemember @rolename = N'db_datareader', @membername = N'svc_inventory_manager_api'
GO
sys.sp_addrolemember @rolename = N'db_datawriter', @membername = N'svc_inventory_manager_api'
GO
