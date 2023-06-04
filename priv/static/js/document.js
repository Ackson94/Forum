$('#submiting').submit(function(e) {
    e.preventDefault()
    let fd = new FormData();
    // let files = $('#attached_file')[0].files;
    // fd.append('data[attached_file]', files[0]);
    // Array.from(files).forEach(file => {
    //     fd.append('data[attached_file]', file);
    // });
    var filesLength = document.getElementById('attached_file').files.length;
    for (var i = 0; i < filesLength; i++) {
        fd.append("attached_file[]", document.getElementById('attached_file').files[i]);
    }
    fd.append('data[document_type]', $('#document_type').val());
    fd.append('data[status]', $('#status').val());
    fd.append('_csrf_token', $('#crf').val());
    fd.append('view', "kenos");
    $('#edit-modal').modal('hide');
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