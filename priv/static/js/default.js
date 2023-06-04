$('#sel1').on('change', function() {
    //  alert( this.value ); // or $(this).val()
    if (this.value == "nrc") {
        $('#nrc-field').show();
        $('#passport-field').hide();
    } else if (this.value == "passport") {
        $('#passport-field').show();
        $('#nrc-field').hide();
    } else {
        $('#nrc-field').hide();
        $('#passport-field').hide();
    }
});


//Dt
$('#dt-user-logs').DataTable();

//user logs report

var txn_report_dtgl = $('#dt-user-log').DataTable({
    "responsive": true,
    "processing": true,
    'language': {
        'loadingRecords': '&nbsp;',
        processing: '<i class="fal fa-spinner fa-spin fa-2x fa-fw"></i><span class="sr-only">Loading...</span> '
    },
    "serverSide": true,
    "paging": true,
    'ajax': {
        "type": "POST",
        "url": '/user/log',
        "data": {
            "_csrf_token": $("#csrf").val(),
            "start_date": $('#start_date').val(),
            "end_date": $('#end_date').val(),

        }
    },

    "columns": [
        { "data": "user" },
        { "data": "user_role" },
        { "data": "activity" },
        { "data": "date" },
        { "data": "host" },


    ],
    "lengthMenu": [
        [10, 25, 50, 100, 500, 1000],
        [10, 25, 50, 100, 500, 1000]
    ],
    "order": [
        [1, 'asc']
    ]
});

$('#stocks').on('click', function() {
    txn_report_dtgl.on('preXhr.dt', function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.start_date = $('#start_date').val();
        data.end_date = $('#end_date').val();
    });
    $('#stock').modal('hide');
    txn_report_dtgl.draw();
});

$('#reload-stocks').on('click', function() {
    txn_report_dtgl.ajax.reload();
});

$('#js-download-stock').click(function() {
    $('#reportSearch1').attr('action', 'csv/stock');
    $('#reportSearch1').attr('method', 'GET');
    $("#reportSearch1").submit();
});

// //

//Dt
$('#dt-user-logs').DataTable();

//email logs report

var txn_report_dtemail = $('#dt-email-log').DataTable({
    "responsive": true,
    "processing": true,
    'language': {
        'loadingRecords': '&nbsp;',
        processing: '<i class="fal fa-spinner fa-spin fa-2x fa-fw"></i><span class="sr-only">Loading...</span> '
    },
    "serverSide": true,
    "paging": true,
    'ajax': {
        "type": "POST",
        "url": '/email/log',
        "data": {
            "_csrf_token": $("#csrf").val(),
            "start_date": $('#start_date').val(),
            "end_date": $('#end_date').val(),

        }
    },

    "columns": [
        { "data": "ticket_no" },
        { "data": "type" },
        { "data": "email" },
        { "data": "inserted_at" },
        { "data": "status" },



    ],
    "lengthMenu": [
        [10, 25, 50, 100, 500, 1000],
        [10, 25, 50, 100, 500, 1000]
    ],
    "order": [
        [1, 'asc']
    ]
});

$('#emails').on('click', function() {
    txn_report_dtemail.on('preXhr.dt', function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.start_date = $('#start_date').val();
        data.end_date = $('#end_date').val();
    });
    $('#email').modal('hide');
    txn_report_dtemail.draw();
});

$('#reload-email').on('click', function() {
    txn_report_dtemail.ajax.reload();
});

$('#js-download-email').click(function() {
    $('#reportSearch2').attr('action', 'csv/email');
    $('#reportSearch2').attr('method', 'GET');
    $("#reportSearch2").submit();
});




///////////Summery report  Start //////////////////////////////////////////////
$('#reload-account-listing').on('click', function() {
    txn_report_dt_account_listing.ajax.reload();
});
//Account Listing pdf
$('#js-download').click(function() {
    $('#reportSearch_account_listing').attr('action', '/download/account/listing/pdf');
    $('#reportSearch_account_listing').attr('method', 'GET');
    $("#reportSearch_account_listing").submit();
});

//Dt
$('#dt-user-logs').DataTable();


//////// Account listing Report //////////////
var txn_report_dt_account_listing = $('#dt-account-listing').DataTable({
    "responsive": true,
    "processing": true,
    'language': {
        'loadingRecords': '&nbsp;',
        processing: '<i class="fal fa-spinner fa-spin fa-2x fa-fw"></i><span class="sr-only">Loading...</span> '
    },
    "serverSide": true,
    "paging": true,
    'ajax': {
        "type": "POST",
        "url": '/summery/report',
        "data": {
            "_csrf_token": $("#csrf").val(),
            "issue_status": $('#issue_status').val(),
            "start_date": $('#start_date').val(),
            "end_date": $('#end_date').val()

        }
    },
    "columns": [

        { "data": "ticket_no" },
        { "data": "bus_name" },
        { "data": "issue" },
        { "data": "issue_status" },
        { "data": "date" },
        { "data": "date_noticed" },


    ],
    "lengthMenu": [
        [10, 25, 50, 100, 500, 1000],
        [10, 25, 50, 100, 500, 1000]
    ],
    "order": [
        [1, 'asc']
    ]
});

$('#accountz').on('click', function() {
    txn_report_dt_account_listing.on('preXhr.dt', function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.issue_status = $('#issue_status').val();
        data.start_date = $('#start_date').val();
        data.end_date = $('#end_date').val();
    });
    $('#account_listing').modal('hide');
    txn_report_dt_account_listing.draw();
});

$('#reload-_account_listing').on('click', function() {
    txn_report_dt_account_listing.ajax.reload();
});





// pdf upload file starts here



$('#submiting_pdf').submit(function(e) {
    e.preventDefault()
    let fd = new FormData();
    let files = document.getElementsByClassName('attached_files_to_pdf');
    for (let i = 0; i < files.length; i++) {
        fd.append("attached_file[]", files[i].files[0]);
    };
    console.log(files)
    fd.append('data[name]', $('#name').val());
    fd.append('_csrf_token', $('#crf').val());

    $('#add-project-pdf').modal('hide');
    Swal.fire({
        title: 'Are you sure you want to Upload?',
        text: "You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/upload/document_maintaince',
                type: 'POST',
                data: fd,
                async: true,
                enctype: 'multipart/form-data',
                processData: false,
                contentType: false,
                success: function(result) {
                    if (result.status === 0) {
                        Swal.fire(
                            'Success',
                            result.message,
                            'success'
                        ).then((_) => {
                            location.reload();
                        })
                    } else {
                        Swal.fire(
                            'Error',
                            result.message,
                            'error'
                        )
                    }
                },
                error: function(request, msg, error) {
                    Swal.fire(
                        'Oops..',
                        error,
                        'error'
                    )
                }
            });
        } else {
            Swal.fire(
                'Cancelled',
                'Operation not performed :)',
                'error'
            )
        }
    })
});






// end of pdf file here



$('#submiting').submit(function(e) {
    e.preventDefault()
    let fd = new FormData();
    let files = document.getElementsByClassName('attached_files_to_run');
    for (let i = 0; i < files.length; i++) {
        fd.append("attached_file[]", files[i].files[0]);
    };
    console.log(files)
    fd.append('data[document_type]', $('#document_type').val());
    fd.append('data[status]', $('#status').val());
    fd.append('_csrf_token', $('#crf').val());
    fd.append('view', "kenos");
    $('#add-project').modal('hide');
    Swal.fire({
        title: 'Are you sure you want to Register?',
        text: "You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/create/document',
                type: 'POST',
                data: fd,
                async: true,
                enctype: 'multipart/form-data',
                processData: false,
                contentType: false,
                success: function(result) {
                    if (result.status === 0) {
                        Swal.fire(
                            'Success',
                            result.message,
                            'success'
                        ).then((_) => {
                            location.reload();
                        })
                    } else {
                        Swal.fire(
                            'Error',
                            result.message,
                            'error'
                        )
                    }
                },
                error: function(request, msg, error) {
                    Swal.fire(
                        'Oops..',
                        error,
                        'error'
                    )
                }
            });
        } else {
            Swal.fire(
                'Cancelled',
                'Operation not performed :)',
                'error'
            )
        }
    })
});



$(document).ajaxStop($.unblockUI);

$('.Add').on('click', function() {
    console.log("data");

    let fd = new FormData();
    // let files = document.getElementsByClassName('user_email');
    // for (let i = 0; i < files.length; i++) {
    //     fd.append("task[]", files[i].files[0]);
    //     fd.append("user_email[]", files[i].files[0]);


    // };

    var task = $.map($('input[name="task[]"]'), function(val_s, _) {
        var newObj = {};
        newObj.task = val_s.value;

        return val_s.value;
    });
    // var codes = $.map($('input[name="codes[]"]'), function(val_s, _) {
    //     var newObj = {};
    //     newObj.codes = val_s.value;

    //     return val_s.value;
    // });
    var email = $.map($('select[name="email[]"]'), function(val, _) {
        var newObj = {};
        newObj.email = val.value;

        return val.value;
    });
    var task_duration = $.map($('input[name="task_duration[]"]'), function(val, _) {
        var newObj = {};
        newObj.task_duration = val.value;

        return val.value;
    });

    var task_status = $.map($('input[name="task_status[]"]'), function(val, _) {
        var newObj = {};
        newObj.task_status = val.value;

        return val.value;
    });

    Swal.fire({
        title: 'Are you sure you want to create a stage?',
        text: "You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            // $.blockUI({ message: `

            //  ` });

            $.ajax({
                url: '/create/project/plan',
                type: 'POST',
                data: {
                    _csrf_token: $('#crf').val(),

                    email: email,
                    task: task,
                    // codes: codes,
                    task_duration: task_duration,
                    task_status: task_status,
                    code: $('#code').val(),
                    stage_start_date: $('#stage_start_date').val(),
                    stage_end_date: $('#stage_end_date').val(),
                    stage_duration: $('#stage_duration').val(),
                    start_date: $('#start_date').val(),
                    end_date: $('#end_date').val(),
                    duration: $('#duration').val(),
                    project_name: $('#project_name').val(),
                    stage_name: $('#stage_name').val()
                },

                success: function(result) {
                    console.log("request")
                    console.log(result)
                    if (result.status === 0) {
                        Swal.fire(
                            'Success',
                            'Successfully',
                            'success'
                        )
                        $('.task').val('');
                        $('.email').val('');
                        // $('.code').val('');
                        $('.code').val('');
                        $('.task_duration').val('');
                        $('.task_status').val('');
                        $('#stage_name').val('');
                        $('#duration').val('');
                        $('#start_date').val('');
                        $('#end_date').val('');
                        // location.reload(true);
                        $('#code').val(result.code);
                        $.unblockUI();
                    } else {
                        Swal.fire(
                            'Error',
                            result.message,
                            'error'
                        )
                    }
                },
                error: function(request, msg, error) {
                    Swal.fire(
                        'Oops..',
                        'Something went wrong! try again',
                        'error'
                    )
                }
            });
        } else {
            Swal.fire(
                'Cancelled',
                'Operation not performed :)',
                'error'
            )
        }
    })
});



///////////////////////////////stage code loopup

$("#stage_name").on("change", function() {
    var trans_codes = $('#stage_name').val();
    if ((trans_codes.trim().length >= 4)) {

        $.ajax({
            url: '/code/lookup',
            type: 'POST',
            data: { trans_codes: trans_codes, _csrf_token: $("#crf").val() },
            success: function(result) {
                if (result.stage_name) {
                    $('#stages').val(result.stage_code.toString());

                } else {
                    Swal.fire(
                        'Oops',
                        result.error,
                        'error'
                    )
                }
            },
            error: function(request, msg, error) {
                Swal.fire(
                    'Oops',
                    'An error occurred. try again!',
                    'error'
                )
            }
        });
    } else {
        return false;
    }
});



//Dt
$('#dt-user-logs').DataTable();
//project report pdf
$('#js-downloads').click(function() {
    $('#reportSearchp').attr('action', '/download/project/report/pdf');
    $('#reportSearchp').attr('method', 'GET');
    $("#reportSearchp").submit();
});

//user logs report---------------------------------start code

var txn_report_dtp_me = $('#dt-account-list-report').DataTable({
    "responsive": true,
    "processing": true,
    'language': {
        'loadingRecords': '&nbsp;',
        processing: '<i class="fal fa-spinner fa-spin fa-2x fa-fw"></i><span class="sr-only">Loading...</span> '
    },
    "serverSide": true,
    "paging": true,
    'ajax': {
        "type": "POST",
        "url": '/view/all/project/report',
        "data": {
            "_csrf_token": $("#csrf").val(),
            "client": $('#client').val(),
            "prjct_name": $('#prjct_name').val(),
            "start_date": $('#start_date').val(),
            "end_date": $('#end_date').val(),
        }
    },

    "columns": [
        { "data": "client" },
        { "data": "prjct_name" },
        { "data": "prjct_purpose" },
        { "data": "prjct_details" },
        { "data": "team_lead" },
        { "data": "planned_end_dt" },
        { "data": "exp_compl_dt" }
    ],
    "lengthMenu": [
        [10, 25, 50, 100, 500, 1000],
        [10, 25, 50, 100, 500, 1000]
    ],
    "order": [
        [1, 'asc']
    ]
});

$('#me_projects').on('click', function() {
    txn_report_dtp_me.on('preXhr.dt', function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.client = $('#client').val();
        data.prjct_name = $('#prjct_name').val();
        data.start_date = $('#start_date').val();
        data.end_date = $('#end_date').val();
    });
    $('#me_report').modal('hide');
    txn_report_dtp_me.draw();
});

$('#reload-project').on('click', function() {
    txn_report_dtp_me.ajax.reload();
});

///// Account Listing CSV Export ///////////
$('#js-download-projects-csv').click(function() {
    $('#reportSearchme').attr('action', '/csv/project');
    $('#reportSearchme').attr('method', 'GET');
    $("#reportSearchme").submit();
});
// //
$('#js-download-projects-excel').click(function() {
    $('#reportSearchme').attr('action', '/excel/account');
    $('#reportSearchme').attr('method', 'GET');
    $("#reportSearchme").submit();
});

// used for download a pdf

$('#js-downloads-pdf_me').click(function() {
    $('#reportSearchme').attr('action', '/download/project/report/pdf');
    $('#reportSearchme').attr('method', 'GET');
    $("#reportSearchme").submit();
});


//////////////END OF ISSUES REPORT //////////////////////



// -----------------------------------------new code


$('#projects').on('click', function() {
    txn_report_dtp.on('preXhr.dt', function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.client = $('#client').val();
        data.prjct_name = $('#prjct_name').val();
        data.start_date = $('#start_date').val();
        data.end_date = $('#end_date').val();
    });
    $('#reports').modal('hide');
    txn_report_dtp.draw();
});

$('#reload-project').on('click', function() {
    txn_report_dtp.ajax.reload();
});

$('#js-download-project').click(function() {
    $('#reportSearchp').attr('action', 'csv/stock');
    $('#reportSearchp').attr('method', 'GET');
    $("#reportSearchp").submit();
});


///// Account Listing CSV Export ///////////
$('#js-download-project-csv').click(function() {
    $('#reportSearchp').attr('action', '/csv/project');
    $('#reportSearchp').attr('method', 'GET');
    $("#reportSearchp").submit();
});
// //
$('#js-download-project-excel').click(function() {
    $('#reportSearchp').attr('action', '/excel/account');
    $('#reportSearchp').attr('method', 'GET');
    $("#reportSearchp").submit();
});



// ISSUES REPORT /////////////////////////////////////////

var txn_report_dtp = $('#dt-issues-report').DataTable({
    "responsive": true,
    "processing": true,
    'language': {
        'loadingRecords': '&nbsp;',
        processing: '<i class="fal fa-spinner fa-spin fa-2x fa-fw"></i><span class="sr-only">Loading...</span> '
    },
    "serverSide": true,
    "paging": true,
    'ajax': {
        "type": "POST",
        "url": '/issues/report/all',
        "data": {
            "_csrf_token": $("#csrf").val(),
            "issue_status": $('#issue_status').val(),
            "start_date": $('#start_date').val(),
            "end_date": $('#end_date').val()
        }
    },

    "columns": [
        { "data": "ticket_no" },
        { "data": "serverity" },
        { "data": "phone_no" },
        { "data": "issue_status" },
        { "data": "platiform" },
        { "data": "developer" },
        { "data": "priority" },
        { "data": "date" }

    ],
    "lengthMenu": [
        [10, 25, 50, 100, 500, 1000],
        [10, 25, 50, 100, 500, 1000]
    ],
    "order": [
        [1, 'asc']
    ]
});

$('#issues_projects').on('click', function() {
    txn_report_dtp.on('preXhr.dt', function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.issue_status = $('#issue_status').val();
        data.serverity = $('#serverity').val();
        data.start_date = $('#start_date').val();
        data.end_date = $('#end_date').val();
    });
    $('#issues_report').modal('hide');
    txn_report_dtp.draw();
});

$('#reload-project').on('click', function() {
    txn_report_dtp.ajax.reload();
});

$('#js-download-project').click(function() {
    $('#reportSearchp').attr('action', 'csv/stock');
    $('#reportSearchp').attr('method', 'GET');
    $("#reportSearchp").submit();
});


///// Account Listing CSV Export ///////////
$('#js-download-issues-csv').click(function() {
    $('#reportSearchpdf').attr('action', '/cvs/download/view');
    $('#reportSearchpdf').attr('method', 'GET');
    $("#reportSearchpdf").submit();
});
// //
$('#js-download-issues-excel').click(function() {
    $('#reportSearchpdf').attr('action', '/excel_account_exp_xlx/excel');
    $('#reportSearchpdf').attr('method', 'GET');
    $("#reportSearchpdf").submit();
});

// used for download a pdf

$('#js-downloads-pdf').click(function() {
    $('#reportSearchpdf').attr('action', '/user/download/pfd');
    $('#reportSearchpdf').attr('method', 'GET');
    $("#reportSearchpdf").submit();
});


//////////////END OF ISSUES REPORT //////////////////////








//  REPORT PLAN/////////////////////////////////////////

var txn_report_plan = $('#dt-project-plan').DataTable({
    "responsive": true,
    "processing": true,
    'language': {
        'loadingRecords': '&nbsp;',
        processing: '<i class="fal fa-spinner fa-spin fa-2x fa-fw"></i><span class="sr-only">Loading...</span> '
    },
    "serverSide": true,
    "paging": true,
    'ajax': {
        "type": "POST",
        "url": '/project/log/plan',
        "data": {
            "_csrf_token": $("#csrf").val(),
            "project_name": $("#project_name").val(),
            "start_date": $('#start_date').val(),
            "end_date": $('#end_date').val()
        }
    },

    "columns": [
        { "data": "project_name" },
        { "data": "stage_start_date" },
        { "data": "stage_end_date" },
        { "data": "stage_duration" },
        { "data": "stage_name" },
        { "data": "start_date" },
        { "data": "end_date" },
        { "data": "duration" },
        { "data": "code" },
        { "data": "responsible" }

    ],
    "lengthMenu": [
        [10, 25, 50, 100, 500, 1000],
        [10, 25, 50, 100, 500, 1000]
    ],
    "order": [
        [1, 'asc']
    ]
});

$('#plan_projects').on('click', function() {
    txn_report_plan.on('preXhr.dt', function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.project_name = $('#project_name').val();
        data.stage_name = $('#stage_name').val();
        data.start_date = $('#start_date').val();
        data.end_date = $('#end_date').val();
    });
    $('#report_plan').modal('hide');
    txn_report_plan.draw();
});

$('#reload-project-plan').on('click', function() {
    txn_report_plan.ajax.reload();
});


///// Account Listing CSV Export ///////////
$('#js-download-plan-csv').click(function() {
    $('#reportSearchcvs').attr('action', '/cvs/download/plan/view');
    $('#reportSearchcvs').attr('method', 'GET');
    $("#reportSearchcvs").submit();
});
// //
$('#js-download-plan-excel').click(function() {
    $('#reportSearchcvs').attr('action', '/excel_account_exp_xlx/excel/plan');
    $('#reportSearchcvs').attr('method', 'GET');
    $("#reportSearchcvs").submit();
});

// used for download a pdf

$('#js-plan-pdf').click(function() {
    $('#reportSearchcvs').attr('action', '/user/plan/pfd');
    $('#reportSearchcvs').attr('method', 'GET');
    $("#reportSearchcvs").submit();
});


//////////////END OF REPORT PLAN //////////////////////










$('#accountz').on('click', function() {
    txn_report_dt_account_listing.on('preXhr.dt', function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.start_date = $('#start_date').val();
        data.end_date = $('#end_date').val();
    });
    $('#account_listing').modal('hide');
    txn_report_dt_account_listing.draw();
});

$('#reload-_account_listing').on('click', function() {
    txn_report_dt_account_listing.ajax.reload();
});