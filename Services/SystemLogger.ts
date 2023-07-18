import { Service } from 'typedi'
import { getConnection, In, Like } from 'typeorm'

import { InjectRepository } from 'typeorm-typedi-extensions'

import { PagingRequest, PagingResponse } from 'Domain/Entities/PagingEntity'
import { SystemLogger } from 'models/SystemLogger'
import { ISystemLoggerService } from 'Domain/IServices/ISystemLogger'
import SystemLoggerRespository from 'Domain/Repositories/SystemLoggerRespository'
import OperationEnum from 'Enums/OperationEnum'
import logger from 'logger'
import { MajorModuleEnum } from 'Enums/MajorModuleEnum'
import { MajorModuleChineseEnum } from 'Enums/MajorModuleChineseEnum'
import { cipher, decipher } from 'Infrastructure'

@Service()
class SystemLoggerService implements ISystemLoggerService {
  constructor(
    @InjectRepository()
    private systemLoggerRepository: SystemLoggerRespository,
  ) { }
  createSystemLogger(data: SystemLogger): void {
    let reminderNew = this.systemLoggerRepository.create(data)
    this.systemLoggerRepository.save(reminderNew)
  }
  insertLogger(userId: number, operation: OperationEnum, operationDetails: string, operationData?: object, moduleName: MajorModuleChineseEnum = MajorModuleChineseEnum.四责协同) {
    try {
      let systemLogger = new SystemLogger()
      systemLogger.userId = userId
      systemLogger.operation = operation
      systemLogger.operationDetails = operationDetails
      // 加密 operationData
      systemLogger.operationDataStr = cipher(JSON.stringify(operationData))
      systemLogger.moduleName = moduleName
      this.createSystemLogger(systemLogger)
    } catch (ex) {
      logger.error('记录系统日志时异常，ex:', ex)
    }
  }
  async getSystemLoggers(ownerId: number, keyword: string, paging: PagingRequest, operationType?: OperationEnum): Promise<PagingResponse<SystemLogger>> {
    let result = await this.systemLoggerRepository.findAndCount({
      where: {
        userId: ownerId,
        // operation: operationType,
      },
      relations: ['user'],
      order: { id: 'DESC' },
      skip: paging.getSkip(),
      take: paging.getTake(),
    })

    let response: PagingResponse<SystemLogger> = {
      data: result[0],
      total: result[1],
    }



    // 解密 data
    if (response.data && response.data.length > 0) {
      response.data.forEach(it => {
        if (it.operationDataStr) {
          let decipherData = decipher(it.operationDataStr)
          if (decipherData) {
            try {
              it.operationData = JSON.parse(decipherData)
            } catch (ex) {
              logger.error('操作日志-解密脱敏数据异常：', ex)
            }
          }
        }
      })
    }

    return response
  }
}

export default SystemLoggerService
