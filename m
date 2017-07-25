From: Michal =?UTF-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>
Subject: tpm: read burstcount from TPM_STS in one 32-bit transaction
Date: Tue, 25 Jul 2017 15:04:43 +0200
Message-ID: <20170725150443.7cf8fc91@kitsune.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe Ricard <christophe.ricard@gmail.com>, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, apronin@chromium.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hello,

in commit 9754d45e9970 ("tpm: read burstcount from TPM_STS in one
32-bit transaction") you change reading of two 8-bit values to one
32bit read. This is obviously wrong wrt endianess unless the
underlying tpm_tis_read32 does endian conversion. 

Looking at the implementation 
static inline int tpm_tis_read32(struct tpm_tis_data *data, u32 addr,
                                 u32 *result)
{
        return data->phy_ops->read32(data, addr, result);
}

it calls read32 which has two implementations:

static const struct tpm_tis_phy_ops tpm_tcg = {
	.read32 = tpm_tcg_read32,

static int tpm_tcg_read32(struct tpm_tis_data *data, u32 addr, u32
*result) {
        struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);

        *result = ioread32(phy->iobase + addr);
       return 0;
}

static const struct tpm_tis_phy_ops tpm_spi_phy_ops = {
	.read32 = tpm_tis_spi_read32,

static int tpm_tis_spi_read32(struct tpm_tis_data *data, u32 addr, u32
*result) {
        int rc;

        rc = data->phy_ops->read_bytes(data, addr, sizeof(u32), (u8
        *)result); if (!rc)
                *result = le32_to_cpu(*result);
        return rc;
}

meaning that unless you are on LE where le32_to_cpu is a noop these
functions do completely different thing. So presumably this is
completely broken on BE. 

Presumably only the SPI variant can be actually used with TPM devices
bolted on after the fact so it is more likely correct for obscure
hardware. Conseqently tpm_tcg_read32 should use
le32_to_cpu(ioread32(phy->iobase + addr)) in case somebody manages to
map a TPM into io-space on a BE machine.

Thanks

Michal
