from subprocess import check_output

if __name__ == '__main__':
    curl = check_output('pbpaste')
    delim = " -H"
    splits = [e+delim for e in curl.split(delim) if e != ""]
    len_splits = len(splits) - 1
    splits[len_splits] = splits[len_splits].replace(delim, "")
    finished = ""
    for i, s in enumerate(splits):
        if "Connection: keep-alive" in s:
            new_delim = "form-data;"
            connection_splits = [e+new_delim for e in s.split(new_delim) if e != ""]
            len_connection_splits = len(connection_splits)-1
            connection_splits[len_connection_splits] = connection_splits[len_connection_splits].replace(new_delim, "")
            for new_i, new_s in enumerate(connection_splits):
                finished += "{0}{1}".format(new_s, "" if new_i == len_connection_splits else "\\\n")
        else:
            finished += "{0}{1}".format(s, "" if i == len_splits else "\\\n")
    print finished
    with open('curl_parse_output.txt', 'w') as f:
        f.write(finished)