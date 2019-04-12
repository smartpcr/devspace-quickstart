FROM microsoft/dotnet:2.2-aspnetcore-runtime

WORKDIR /api
COPY bin/Debug/netcoreapp2.2/publish .

ENTRYPOINT ["dotnet", "generator-api.dll"]