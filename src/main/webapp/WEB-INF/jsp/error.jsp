<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${(empty sessionScope.lang) ? 'fr': sessionScope.lang}"/>

<fmt:setBundle basename="messages"/>

<!DOCTYPE html>
<html lang="fr">
    <head>
        <meta http-equiv="Content-type" content="text/html; charset=utf-8">
        <title><fmt:message key="label.error"/></title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="/style.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </head>
    <body>

        <div class="container my-5">
            <h2 class="mb-4 text-danger"><fmt:message key="label.error"/></h2>

            <div class="row justify-content-center">
                <div class="col-lg-6">
                    <div class="card shadow-sm">
                        <div class="card-header bg-danger text-white">
                            <fmt:message key="label.something_wrong"/>
                        </div>
                        <div class="card-body">
                            <p class="text-muted"><fmt:message key="label.error"/></p>
                            <a href="/" class="btn btn-primary">
                                <i class="bi bi-arrow-left-circle me-2"></i> <fmt:message key="label.back_to_planning"/>
                            </a>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <footer class="fixed-bottom bg-light">
            <div class="d-flex border-top p-3">
                <span>&copy; Florine Lefebvre & Charlie Darques</span>
            </div>
        </footer>
    </body>
</html>
