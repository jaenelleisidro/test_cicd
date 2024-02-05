
enable workflow
Settings -> Action -> General -> Workflow permissions and choose read and write permissions


add/change workflows?
you need to use PAT on your sourcetree
go to github> settings > developer settings > personal access token (PAT)
generate a token that contains workflow scope
assign this PAT to your sourcetree or whichever git client you'are using

more info here
https://stackoverflow.com/questions/64059610/how-to-resolve-refusing-to-allow-an-oauth-app-to-create-or-update-workflow-on



in source you can assign PAT by going token
tools > options>  authentication >
add a new account (delete existing account if you're already authenticated) > 
change hosting service to githubchange authentication to personal access token
click refresh personal access token
username  << enter github email
password << enter your PAT