// src/services/feeService.ts
import axios from 'axios';
import { logger } from '../utils/logger';
import ConfigModel from '../models/configModel';
import chalk from 'chalk';

interface ProjectConfig {
    unisatAPIKey: string;
    feesUsing: 'slow' | 'medium' | 'fast';
    maxGas: number;
    gasCheckerSleep: [number, number];
    sleep: [number, number];
    batchCount: number;
    batchSleep: [number, number];
}

class FeeService {
    static async fetchFees(networkType: 'bitcoin' | 'fractal'): Promise<number> {
        const projectConfigData = ConfigModel.getConfig('projectConfig') as ProjectConfig;
        try {
            // logger.info(chalk.cyan(`🔍 Получение рекомендуемых комиссий с mempool.space для сети ${networkType}`));
            let apiUrl = 'https://mempool.space/api/v1/fees/recommended';
            if (networkType === 'fractal') {
                apiUrl = 'https://mempool.fractalbitcoin.io/api/v1/fees/recommended';
            }
            const response = await axios.get(apiUrl);
            const fee = projectConfigData.feesUsing;
            const acceptFees: { [key: string]: string } = {
                slow: networkType === 'fractal' ? 'hourFee' : 'minimumFee',
                medium: networkType === 'fractal' ? 'halfHourFee' : 'economyFee',
                fast: networkType === 'fractal' ? 'fastestFee' : 'fastestFee',
            };
            const currentFee = response.data[acceptFees[fee]];
            logger.info(chalk.green(`✅ Текущая комиссия для "${fee}" на ${networkType}: ${currentFee} sats/vByte`));
            return currentFee;
        } catch (error: any) {
            logger.error(chalk.red(`❌ Ошибка при получении рекомендуемых комиссий: ${error.message}`));
            throw error;
        }
    }
}

export default FeeService;
