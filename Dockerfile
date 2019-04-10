FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.2-sdk AS build
RUN useradd -m dotnet
WORKDIR /src
COPY --chown=dotnet . .
WORKDIR /src/src/HelloWorldApi
RUN dotnet restore HelloWorldApi.csproj -nowarn:msb3202,nu1503
RUN dotnet build HelloWorldApi.csproj --no-restore -c Release -o /app

FROM build AS publish
RUN dotnet publish --no-restore -c Release -o /app

FROM base AS final
RUN useradd -m dotnet
WORKDIR /app
COPY --chown=dotnet --from=publish /app .
ENTRYPOINT ["dotnet", "HelloWorldApi.dll"]
