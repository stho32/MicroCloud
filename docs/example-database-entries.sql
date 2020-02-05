INSERT INTO Node (Name, RAMAvailableTotalInGB ) VALUES ( 'MASTER', 32-6)
INSERT INTO Node (Name, RAMAvailableTotalInGB ) VALUES ( 'NODE01', 32-6)
INSERT INTO Node (Name, RAMAvailableTotalInGB ) VALUES ( 'NODE02', 32-6)

INSERT INTO Configuration (Name, Value, Description)
SELECT 'VMNamesStartWith', 'MicroVM-', 'When creating VMs all their names start with this string.' UNION ALL
SELECT 'TheMastersLocalImageDirectoryBeforeDistribution', 'C:\Users\Public\Documents\Hyper-V\Virtual hard disks', 'We create disk images in the default Hyper-V directory on the master. That is the source directory for distribution of images.' UNION ALL
SELECT 'TheNodesLocalImageDirectory', 'C:\Projekte\Images', 'Every node, including the master, has this directory. Thats where we store the disk images that are the real base images for our VMS.' 

INSERT INTO Configuration (Name, Value, Description) VALUES ('EntranceRouterInternalIP', '192.168.88.1', 'Cloud internal IP of the entrance router (SSH)')
INSERT INTO Configuration (Name, Value, Description) VALUES ('EntranceRouterExternalIP', '192.168.0.130', 'Cloud external IP of the entrance router (the face to the users)')
INSERT INTO Configuration (Name, Value, Description) VALUES ('MasterIP', '192.168.88.2', 'IP of the cloud master')
INSERT INTO Configuration (Name, Value, Description) VALUES ('EntranceRouterPortRangeStart', '4000', 'port range start for port forwardings to the outside')
INSERT INTO Configuration (Name, Value, Description) VALUES ('EntranceRouterPortRangeEnd', '8079', 'port range end for port forwardings to the outside')
INSERT INTO Configuration (Name, Value, Description) VALUES ('EntranceRouterUsername', 'admin', 'user name for entrance router (SSH)')
INSERT INTO Configuration (Name, Value, Description) VALUES ('EntranceRouterPassword', 'password', 'password for entrance router (SSH)')

