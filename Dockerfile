FROM mcr.microsoft.com/dotnet/runtime:6.0 AS base
WORKDIR /app

# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# copy csproj and restore as distinct layers
COPY *.csproj ./ 
COPY  ./vscode.csproj /src/
RUN dotnet restore
COPY . .
WORKDIR /src/
RUN dotnet build -c release -o /app 

# copy and publish app and libraries

FROM build AS publish 
RUN dotnet publish -c release -o /app 

# final stage/image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/ .
ENTRYPOINT ["dotnet", "vscode.dll"]