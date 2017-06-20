From: Ken Goldman <kgold@linux.vnet.ibm.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm: consolidate the TPM startup code
Date: Tue, 20 Jun 2017 16:58:19 -0400
Message-ID: <ba8acc37-f751-ddbf-48a0-e5ece6cecbd2@linux.vnet.ibm.com>
References: <20170620181334.28363-1-jarkko.sakkinen@linux.intel.com>
 <20170620193152.GA3368@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170620193152.GA3368@obsidianresearch.com>
Content-Language: en-US
Sender: owner-linux-security-module@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On 6/20/2017 3:31 PM, Jason Gunthorpe wrote:
>> 
>> +#define TPM_ORD_STARTUP 153 +#define TPM_ST_CLEAR 1
> 
> We should really have a tpm1.h and tpm2.h that has all these various 
> constants and things instead of open coding them randomly all over..

While you're doing that, perhaps put the ordinal numbers in hex.  The
TPM 1.2 spec uses both hex and decimal, but TPM 2.0 uses hex.

