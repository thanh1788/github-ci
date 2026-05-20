FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY ["MyWebApp.csproj", "."]
RUN dotnet restore "./MyWebApp.csproj"
COPY . .
RUN dotnet build "MyWebApp.csproj" -c Release -o /app/build

# Giai đoạn 2: Xuất bản tệp tin thực thi (.dll)
FROM build AS publish
RUN dotnet publish "MyWebApp.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Giai đoạn 3: Môi trường chạy siêu nhẹ (Runtime)
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .
EXPOSE 8080
ENTRYPOINT ["dotnet", "MyWebApp.dll"]
