From: Michal =?UTF-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>
Subject: ibmvtpm byteswapping inconsistency
Date: Thu, 26 Jan 2017 21:22:48 +0100
Message-ID: <20170126212248.3f3e9103@kitsune.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ashley Lai <ashleydlai@gmail.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hello,

building ibmvtpm I noticed gcc warning complaining that second word of
struct ibmvtpm_crq in tpm_ibmvtpm_suspend is uninitialized.

The structure is defined as 

struct ibmvtpm_crq {
        u8 valid;
        u8 msg;
        __be16 len;
        __be32 data;
        __be64 reserved;
} __attribute__((packed, aligned(8)));

initialized as

        struct ibmvtpm_crq crq;
        u64 *buf = (u64 *) &crq;
...
        crq.valid = (u8)IBMVTPM_VALID_CMD;
        crq.msg = (u8)VTPM_PREPARE_TO_SUSPEND;

and submitted with

        rc = ibmvtpm_send_crq(ibmvtpm->vdev, cpu_to_be64(buf[0]),
                              cpu_to_be64(buf[1]));

which means that the second word indeed contains purely garbage.

This is repeated a few times in the driver so I added memset to quiet
gcc and make behavior deterministic in case the unused fields get some
meaning in the future.

However, in tpm_ibmvtpm_send the structure is initialized as

	struct ibmvtpm_crq crq;
        __be64 *word = (__be64 *)&crq;
...
        crq.valid = (u8)IBMVTPM_VALID_CMD;
        crq.msg = (u8)VTPM_TPM_COMMAND;
        crq.len = cpu_to_be16(count);
        crq.data = cpu_to_be32(ibmvtpm->rtce_dma_handle);

and submitted with

	rc = ibmvtpm_send_crq(ibmvtpm->vdev, be64_to_cpu(word[0]),
                              be64_to_cpu(word[1]));
meaning it is swapped twice.


Where is the interface defined? Are the command arguments passed as BE
subfields (the second case was correct before adding the extra whole
word swap) or BE words (the first case doing whole word swap is
correct)?

Thanks

Michal
