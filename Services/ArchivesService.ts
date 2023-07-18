import { Service } from 'typedi'
import { getConnection, In, Like } from 'typeorm'

import { InjectRepository } from 'typeorm-typedi-extensions'
import UserRepository from 'Domain/Repositories/UserRepository'

import { IArchivesService } from 'Domain/IServices/IArchivesService'
import { PagingRequest, PagingResponse } from 'Domain/Entities/PagingEntity'
import ArchivesRepository from 'Domain/Repositories/ArchivesRepository'
import ArchivesTypeEnum from 'Enums/ArchivesTypeEnum'
import { Archives } from 'models/Archives'
import { computDateRange, decipher, getDateRangeName } from 'Infrastructure'
import logger from 'logger'
import DateRangeTypeEnum from 'Enums/DateRangeTypeEnum'

@Service()
class ArchivesService implements IArchivesService {
  constructor(
    @InjectRepository()
    private archivesRepository: ArchivesRepository,

    @InjectRepository()
    private userRepository: UserRepository,
  ) { }

  async createArchives(data: Archives): Promise<boolean> {
    let dataNew = this.archivesRepository.create(data)
    return !!(await this.archivesRepository.save(dataNew))
  }

  async getArchivesByUser(userId: number, archivesType: ArchivesTypeEnum, paging: PagingRequest): Promise<PagingResponse<Archives>> {
    let result = await this.archivesRepository.findAndCount({
      where: {
        userId: userId,
        archivesType: archivesType,
      },
      relations: ['org', 'entity', 'user'],
      order: { id: 'DESC' },
      skip: paging.getSkip(),
      take: paging.getTake(),
    })

    let response: PagingResponse<Archives> = {
      data: result[0],
      total: result[1],
    }

    // 解密 data
    if (response.data && response.data.length > 0) {
      response.data.forEach(it => {
        if (it.entity.dataStr) {
          let decipherData = decipher(it.entity.dataStr)
          if (decipherData) {
            try {
              it.entity.data = JSON.parse(decipherData)
            } catch (ex) {
              logger.error('解密脱敏数据异常：', ex)
            }
          }
        }
      })
    }
    return response
  }

  async getArchiveByUser(userId: number, archivesType: ArchivesTypeEnum): Promise<Archives | undefined> {

    let archive = await this.archivesRepository.findOne({
      where: {
        userId: userId,
        archivesType: archivesType,
      },
      relations: ['org', 'entity', 'user'],
      order: { id: 'DESC' },
    })

    // 解密 data
    if (archive && archive.id > 0) {
      if (archive.entity.dataStr) {
        let decipherData = decipher(archive.entity.dataStr)
        if (decipherData) {
          try {
            archive.entity.data = JSON.parse(decipherData)
          } catch (ex) {
            logger.error('解密脱敏数据异常：', ex)
          }
        }
      }
    }

    return archive
  }

  async getDisciplinaryArchives(orgId: number, keyword: string): Promise<Archives[]> {
    let whereOptions: any = {
      archivesType: ArchivesTypeEnum.帮教列管,
    }

    if (orgId && orgId > 0) {
      whereOptions.orgId = orgId
    }

    if (keyword && keyword !== '') {
      whereOptions.keywords = Like(`%${keyword}%`)
    }
    let result = await this.archivesRepository.find({
      where: whereOptions,
      relations: ['org', 'entity', 'user'],
      order: { id: 'DESC' },
    })

    return result
  }

  // 获取列管记录
  async getDisciplinaryByUser(userId: number): Promise<Archives[]> {
    let whereOptions: any = {
      userId: userId,
      archivesType: ArchivesTypeEnum.帮教列管,
    }

    let result = await this.archivesRepository.find({
      where: whereOptions,
      relations: ['org', 'entity', 'user'],
      order: { id: 'DESC' },
    })

    // 解密 data
    if (result && result.length > 0) {
      result.forEach(it => {
        if (it.entity.dataStr) {
          let decipherData = decipher(it.entity.dataStr)
          if (decipherData) {
            try {
              it.entity.data = JSON.parse(decipherData)
            } catch (ex) {
              logger.error('解密脱敏数据异常：', ex)
            }
          }
        }
      })
    }

    return result
  }

  async getCurrentDisciplinaryArchives(): Promise<Archives[]> {

    const currentRange = computDateRange(DateRangeTypeEnum.季)
    let sql = `
    select E.dateRange,
      A.userId
      from archives as A
      left join entity as E
      on E.id = A.entityId
      where
      E.deletedAt is null
      and A.deletedAt is null
      and E.dateRange = ${currentRange}
      and A.archivesType= '${ArchivesTypeEnum.帮教列管}'
    `
    return await getConnection().query(sql);
  }

  async deleteArchivesByEntityId(entityId: number): Promise<void> {
    await this.archivesRepository.softDelete({entityId})
  }

}

export default ArchivesService
