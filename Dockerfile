#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY . .
RUN dotnet restore WebAppJenkinsDocker.csproj
RUN dotnet build WebAppJenkinsDocker.csproj -c Release -o /publish/
RUN dotnet publish WebAppJenkinsDocker.csproj -c Release -o /publish/

FROM base AS final
WORKDIR /app
COPY --from=build /src/bin/Release/net5.0/ .
ENTRYPOINT ["dotnet", "WebAppJenkinsDocker.dll"]
