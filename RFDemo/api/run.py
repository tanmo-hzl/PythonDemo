import argparse
import configparser
import os


def main():

    file_path = os.path.dirname(os.path.abspath(__file__))
    config_path = os.path.join(file_path, 'config.ini')
    config = configparser.ConfigParser()
    config.read(config_path)
    defaultcase_path = '.'
    defaultcase_path = os.path.join(defaultcase_path, 'TestCase')
    defaultcase_path = os.path.join(defaultcase_path, 'API_Portal')
    file_path = os.path.join(file_path, 'TestData')
    file_path = os.path.join(file_path, 'API_Portal')
    file_path = os.path.join(file_path, 'config.robot')
    paser = argparse.ArgumentParser()
    paser.add_argument('--env')
    paser.add_argument('--apikey')
    paser.add_argument('--readkey')
    paser.add_argument('--tag')
    paser.add_argument('--loglevel')
    paser.add_argument('--path')
    args = paser.parse_args()
    api_key = args.apikey
    read_key = args.readkey
    tag = args.tag
    if not tag:
        tag = 'smoke'
    loglevel = args.loglevel
    if not loglevel:
        loglevel = 'debug'
    path = args.path
    if not path:
        path = defaultcase_path
    f = open(file_path,'r')
    all_data = f.readlines()
    all_data.pop()
    all_data.pop()
    all_data.pop()
    if args.env == 'tst03' or args.env == 'qa':
        url = 'https://mik.qa.platform.michaels.com/api/mda'
        if not api_key:
            api_key = '018f83b26b35e8536443e115c710d4e0049622620696244a4c03f734e69d4bef898ac5f9a5bbb1cb'
        if not read_key:
            read_key = '2d87cf4402a8e58431e8ab3b640111a2ee578130ab7045fb6ae01a39cb6ab8c1346f84fbb7f82f78'
    elif args.env == 'tst02' or args.env == 'stg':
        url = 'https://mik.stg.platform.michaels.com/api/mda'
        if not api_key:
            api_key = 'e5e3cbb27c3bef36e73a05d1c2f8b717f53b8933f0e3e3fe93cafa2567a34c54cdbd4eee144987d4'
        if not read_key:
            read_key = '4ae144a0696ac75a9f7aa0fe1b705787f753f7226b44a96b1420cb851f60ae52f8290c238b89c94f'
    elif args.env == 'aps':
        url = 'https://mda.aps.platform.michaels.com/api'
        if not api_key:
            api_key = '91d12621f060e2c6cd977b5ad25ff0bead7c67e5e884b86a61d663013fa1a25d3c9baf654966a641'
        if not read_key:
            read_key = '9cb7d2dc50cecf2a1413e4c3d0b4ced82616b7fef742210aa6668a9649e7f5b1f7efc6b651ca076b'
    else:
        print("""
        请输入参数
        --env：测试环境，必须
        --apikey：测试用的apikey
        --readkey：测试用读取权限apikey
        --tag：测试用例的tag，默认为smoke
        --loglevel：robot日志等级，默认为debug
        --path：测试用例所在目录，默认为 \\TestCase\\API_Portal\\
        """)
        return

    config.set('API_Portal', 'url', url)
    config.set('API_Portal', 'api_key', api_key)

    data = '${base_url}   ' + url + '\n'
    all_data.append(data)
    data = '${api_key}     ' + api_key + '\n'
    all_data.append(data)
    data = '${read_api_key}    ' + read_key + '\n'
    all_data.append(data)
    with open(config_path,'w+') as f:
        config.write(f)

    f.close()
    f = open(file_path, 'w')
    f.writelines(all_data)
    f.close()
    print(rf'robot --loglevel={loglevel} -i {tag} {path}')
    os.system(rf'robot --loglevel={loglevel} -i {tag} {path}')


if __name__ == '__main__':

    main()






