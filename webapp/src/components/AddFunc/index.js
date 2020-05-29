import React, { Component } from 'react'

import {Form, Input, Upload, Button, message} from 'antd'
import { UploadOutlined } from '@ant-design/icons';

import ParamForFunc from './ParamForFunc'

import "./style.css"

const props = {
    name: 'file',
    action: 'https://www.mocky.io/v2/5cc8019d300000980a055e76',
    headers: {
      authorization: 'authorization-text',
    },
    onChange(info) {
      if (info.file.status !== 'uploading') {
        console.log(info.file, info.fileList);
      }
      if (info.file.status === 'done') {
        message.success(`${info.file.name} file uploaded successfully`);
      } else if (info.file.status === 'error') {
        message.error(`${info.file.name} file upload failed.`);
      }
    },
  };

class AddFunc extends Component {
    render() {
        return (
          <div>
            <Form name="funcInfo" >
                <div className="input-block">
                    Название функции:
                    <Input name="nameFunc" disabled={this.props.isDisabled} />
                    <Button style={{position: 'absolute', marginLeft: '30px'}} type='primary'>Добавить функцию</Button>
                </div>
                <div className="input-block">
                    <Upload name="fileFunc" {...props}>
                        <Button disabled={this.props.isDisabled}><UploadOutlined /> Загрузить файл</Button>
                    </Upload>
                </div>
                <div className="input-block">
                    Относительный путь запускаемого файла:
                    <Input name="pathFunct" disabled={this.props.isDisabled}/>
                </div>
                <div style={{marginLeft: '150px'}}>
                    <ParamForFunc isDisabled = {this.props.isDisabled}/>
                </div>
            </Form>
          </div>
        )
    }
}

export default AddFunc
