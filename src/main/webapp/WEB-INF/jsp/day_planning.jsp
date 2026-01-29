<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${(empty sessionScope.lang) ? 'fr': sessionScope.lang}"/>

<fmt:setBundle basename="messages"/>

<fmt:message key="label.booked" var="labelBooked"/>
<fmt:message key="label.book_slot" var="labelBookSlot"/>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-type" content="text/html; charset=utf-8">
        <title>${appTitle} - <fmt:message key="label.planning_of_day"/> ${formattedDate}</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="/style.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
        <link rel="icon" type="image/png" href="${appFavicon}">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </head>
    <header>
        <!-- NAVBAR -->
        <nav class="navbar navbar-expand bg-light">
            <div class="container-fluid">
                <span class="navbar-brand">
                    <img src="${appFavicon}" width="32px">
                    ${appTitle}
                </span>
                
                <div class="collapse navbar-collapse" id="navbarContent">
                    <ul class="navbar-nav me-auto">
                        <li class="nav-item">
                            <a class="nav-link" href="planning"><fmt:message key="label.planning"/></a>
                        </li>

                        <li class="nav-item">
                            <a class="nav-link" href="compte"><fmt:message key="label.account"/></a>
                        </li>

                    <c:if test="${role == 'admin'}">
                        <li class="nav-item">
                            <a class="nav-link" href="panel_admin"><fmt:message key="label.admin_panel"/></a>
                        </li>
                    </c:if>
                    </ul>

                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item">
                            <form:form action="/logout" method="post">
                                <c:if test="${_csrf != null}">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                </c:if>
                                <button class="btn btn-outline-danger"><fmt:message key="label.logout"/></button>
                            </form:form>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
    </header>
    <body>
        <!-- CONTENEUR GLOBAL -->
        <div class="container my-4 p-4 shadow-lg rounded-4 bg-light">

        <c:if test="${not empty message}">
            <p class="text-success text-center">${message}</p>
        </c:if>

            <!-- TITRE -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-bold text-primary">
                <i class="bi bi-calendar3"></i> <fmt:message key="label.daily_planning"/>
                </h2>
            </div>

            <!-- JOUR -->
            <div id="day_planning" class="text-center">

                <span class="d-flex justify-content-between mb-4">
                    <a class="btn btn-outline-secondary" href="day_planning?date=${previousDate}"><i class="bi bi-arrow-left-circle-fill"></i> <fmt:message key="label.previous_day"/></a>
                    <h3 class="fw-semibold"><fmt:message key="label.slots_of"/> <span class="text-success">${formattedDate}</span></h3>
                    <a class="btn btn-outline-secondary" href="day_planning?date=${nextDate}"><fmt:message key="label.next_day"/> <i class="bi bi-arrow-right-circle-fill"></i></a>
                </span>

                <!-- SLOTS -->
                <div class="row g-4 justify-content-center">

                    <c:if test="${closed}">
                        <div class="card border-0 shadow-sm rounded-4 p-1 bg-white h-100 w-50">
                            <h3 class="mb-3 text-danger"><fmt:message key="label.closed_today"/> ⚠️</h3>
                        </div>
                    </c:if>

                    <c:if test="${pastDay and !closed}">
                        <div class="card border-0 shadow-sm rounded-4 p-1 bg-white h-100 w-50">
                            <h3 class="mb-3 text-danger"><fmt:message key="label.past_day"/> ⚠️</h3>
                        </div>
                    </c:if>

                    <c:if test="${empty slots and !closed}">
                        <div class="card border-0 shadow-sm rounded-4 p-1 bg-white h-100 w-50">
                            <h3 class="mb-3 text-danger"><fmt:message key="label.no_slot"/></h3>
                        </div>
                    </c:if>

                    <c:if test="${!closed and !pastDay}">
                        <c:forEach items="${slots}" var="slot">  
                            <c:if test="${!today or slot.timeStart > timeHour}">
                                <c:set var="userBookedIt" 
                                    value="${fn:contains(userSlots, '' + slot.idSlot) and !slot.virtual}"/>
                                <div class="col-md-5">
                                    <div class="slot_details card border-0 shadow-sm rounded-4 p-3 bg-white h-100">
                                        <div class="text-center mb-4 fw-semibold text-primary">
                                            <i class="bi bi-clock"></i> ${slot.timeStart} - ${slot.timeEnd}
                                        </div>
                                        
                                        <c:if test="${!slot.virtual}">
                                            <p class="text-muted small mb-1"><fmt:message key="label.capacity"/> : ${slot.reservationCount}/${capacity}</p>
                                            <div class="progress" style="height: 12px;">
                                                <div class="progress-bar ${userBookedIt ? 'bg-primary' : 'bg-secondary'}" style="width: ${slot.capacityPercentage}%;"></div>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${slot.virtual}">
                                            <p class="text-muted small mb-1"><fmt:message key="label.no_booking"/></p>
                                            <div class="progress" style="height: 12px;">
                                                <div class="progress-bar ${userBookedIt ? 'bg-primary' : 'bg-secondary'}" style="width: 0%;"></div>
                                            </div>
                                        </c:if>
                                        
                                        <form:form action="insert_booking" method="post">
                                            <c:if test="${!slot.virtual}">
                                                <input type="hidden" name="id_slot" value="${slot.idSlot}">
                                            </c:if>
                                            <input type="hidden" name="date" value="${date}">
                                            <input type="hidden" name="time_start" value="${slot.timeStart}">
                                            <input type="hidden" name="time_end" value="${slot.timeEnd}">
                                            <input type="hidden" name="login" value="${login}">
                                            
                                            <button class="btn ${userBookedIt ? 'btn-primary' : 'btn-secondary'} mt-3 w-100 rounded-3" 
                                                    ${!slot.virtual && slot.reservationCount >= capacity ? 'disabled' : ''}>
                                                <i class="bi bi-check-circle"></i> 
                                                ${userBookedIt ? labelBooked : labelBookSlot}
                                            </button>
                                        </form:form>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </c:if>
                </div>
                <a class="btn btn-outline-secondary mt-4 mb-5" href="/">
                    <i id="goBack" class="bi bi-arrow-left"></i> 
                    <fmt:message key="label.back_to_planning"/>
                </a>
            </div>
        </div>
    </body>

    <footer class="fixed-bottom bg-light">
        <div class="d-flex justify-content-between border-top p-3">
            <span>${appTitle} &copy;</span>
            <span>Florine Lefebvre & Charlie Darques</span>
        </div>
    </footer>
</html>
